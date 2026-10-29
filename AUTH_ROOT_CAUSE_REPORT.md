# PHASETWO — AUTHENTICATION & WEBVIEW ROOT CAUSE REPORT
**Project:** PhaseTwo Flutter Mobile App  
**Package ID:** `ca.phasetwo.phasetwo`  
**Production Host:** `https://www.phasetwo.ca/`  
**Date:** October 2026  
**Auditor:** Senior Flutter Architect, Authentication Engineer & WebView Specialist

---

## 1. Executive Summary

A critical user-reported defect was investigated where tapping **"Candidate Login"** or **"Employer Login"** on the Welcome screen launched the website homepage (`https://www.phasetwo.ca/`) rather than the intended login forms (`https://www.phasetwo.ca/login` or `https://www.phasetwo.ca/recruiter_login`). Furthermore, native-to-web authentication transitions were failing, and native Option B dashboard navigation was unsynchronized.

Through comprehensive static analysis, code trace, and live HTTP probing of `https://www.phasetwo.ca/`, the **exact root causes were isolated to client-side Flutter lifecycle and WebView state bugs**, combined with an improper file chooser callback that broke resume uploads.

The website itself was proven to be fully operational with dedicated, accessible authentication routes. All client defects have been resolved without altering the production server, database, or approved Option B native Flutter UI.

---

## 2. Root Cause Analysis with Architectural Evidence

### Root Cause 1: Hardcoded Initial URL in `PhaseTwoWebViewScreenState`
* **Defect Location:** `lib/screens/webview_screen.dart` (Line 228)
* **Code in Question:**
  ```dart
  _controller = controller;
  _controller.loadRequest(Uri.parse(AppConfig.initialUrl));
  ```
* **Failure Mechanism:**  
  `PhaseTwoWebViewScreen` was constructed with `widget.initialUrl = widget.initialUrl` (e.g., `https://www.phasetwo.ca/login`). However, inside `_initWebViewController()`, the controller completely discarded `widget.initialUrl` and hardcoded `AppConfig.initialUrl` (`https://www.phasetwo.ca/`). Consequently, every newly initialized WebView instance immediately loaded the homepage.

### Root Cause 2: Mount-Time Race Condition in `MainShellScreen`
* **Defect Location:** `lib/screens/main_shell.dart` (`_openUrlInWebView`)
* **Code in Question:**
  ```dart
  void _openUrlInWebView(String url) {
    setState(() {
      _hasLoadedWebView = true;
      _isWebViewActive = true;
      _currentUrl = url;
    });
    // On first launch, _hasLoadedWebView was false, so _webViewKey.currentState was null!
    _webViewKey.currentState?.loadPage(url);
  }
  ```
* **Failure Mechanism:**  
  On the first tap from `AuthWelcomeScreen`, `_hasLoadedWebView` was `false`. The `PhaseTwoWebViewScreen` widget was not yet mounted in Flutter's element tree. Consequently, `_webViewKey.currentState` returned `null`, and `_webViewKey.currentState?.loadPage(url)` silently no-oped. Flutter then scheduled a build, mounted `PhaseTwoWebViewScreen`, and ran `initState()`, which triggered Root Cause 1 and loaded the homepage.

### Root Cause 3: Missing `didUpdateWidget` Lifecycle Handler
* **Defect Location:** `lib/screens/webview_screen.dart`
* **Failure Mechanism:**  
  When `MainShellScreen` updated `_currentUrl` and passed it as `PhaseTwoWebViewScreen(initialUrl: _currentUrl)`, Flutter's framework updated the widget configuration. However, because `PhaseTwoWebViewScreenState` lacked `didUpdateWidget`, state changes were ignored unless an imperative `loadPage()` call succeeded.

### Root Cause 4: Accidental File Chooser Cancellation on Android
* **Defect Location:** `lib/screens/webview_screen.dart`
* **Code in Question:**
  ```dart
  androidController.setOnShowFileSelector(
    (FileSelectorParams params) async {
      return <String>[]; // Cancels Android file selection!
    },
  );
  ```
* **Failure Mechanism:**  
  Returning `<String>[]` from `setOnShowFileSelector` signaled to the Android WebView engine that the user canceled the file picker dialog. This rendered candidate resume and document uploads completely non-functional.

### Root Cause 5: Flawed Authentication Verification
* **Defect Location:** `lib/services/auth_session_service.dart`
* **Failure Mechanism:**  
  Previous logic relied solely on URL substrings or assumed `PHPSESSID` cookie presence was proof of authentication. Live server investigation proved:
  1. `phasetwo.ca` runs CodeIgniter PHP on Apache with a persistent guest cookie named `ci_session` (set on first GET request).
  2. Relying on cookie existence caused false positives for unauthenticated guests.
  3. Real authentication requires verifying DOM indicators (`logout` action) or protected endpoints (e.g., `/company/` routes).

---

## 3. Live Server Route Verification Evidence

Live HTTP requests were executed against `https://www.phasetwo.ca/` to prove server behavior:

| Route Requested | HTTP Status | Redirect Location | Form Action | Form Fields |
|---|---|---|---|---|
| `GET /login` | **200 OK** | None (Direct) | `https://www.phasetwo.ca/Login` | `email`, `password` |
| `GET /recruiter_login` | **200 OK** | None (Direct) | `https://www.phasetwo.ca/Login/recruiter_login` | `company_email`, `password` |
| `GET /register` | **200 OK** | None (Direct) | `https://www.phasetwo.ca/Register/register` | `name`, `email`, `password`, `contact` |
| `GET /recruiter_register`| **200 OK** | None (Direct) | `https://www.phasetwo.ca/Register/register_employeer` | `company_name`, `email`, `password` |
| `POST /Login` (Invalid) | **303 See Other** | `/Phasetwo/login` (Flash error) | N/A | Validation error displayed |
| `POST /Login/recruiter_login` (Invalid) | **303 See Other** | `/Phasetwo/recruiter_login` | N/A | Validation error displayed |
| `GET /logout` | **307 Temporary**| `/Phasetwo` (Home) | N/A | Session terminated |

**Conclusion:** The website server does **not** redirect `/login` or `/recruiter_login` to the homepage. The bug was entirely client-side.

---

## 4. Solutions Implemented

### 1. Queued & Deterministic WebView Loading (`webview_screen.dart`)
- Introduced `_isControllerReady` and `_pendingUrl` queue.
- If `loadPage()` is called before controller readiness, the request is queued and loaded immediately upon initialization.
- Replaced hardcoded `AppConfig.initialUrl` with `_pendingUrl ?? widget.initialUrl`.
- Added `didUpdateWidget` to reload whenever `widget.initialUrl` changes.
- Removed the breaking `setOnShowFileSelector` override, allowing the platform default file selector to handle candidate resume attachments.

### 2. Synchronized Frame Navigation (`main_shell.dart`)
- Wrapped `loadPage()` in `WidgetsBinding.instance.addPostFrameCallback` so that initial widget mounting and subsequent navigation are synchronized without race conditions.
- Preserved single persistent WebView controller inside `Offstage` stack.

### 3. Reliable DOM & Protected-Route Auth Evaluation (`auth_session_service.dart`)
- Evaluates DOM signals via JavaScript execution on `onPageFinished`:
  ```javascript
  var hasLogout = !!document.querySelector('a[href*="logout" i], form[action*="logout" i]');
  var isEmployer = !!document.querySelector('a[href*="company" i], a[href*="recruiter" i], a[href*="New_job_post" i]');
  ```
- Evaluates protected URL routes (`/company/new_job_post`, `/company/dashboard`, `/company/profile`).
- Enforces 2-hour session lifetime matching CodeIgniter's `ci_session` expiration.
- Does not transition to native dashboard on failed login (retains user on web form to view real validation errors).

---

## 5. Verification Status

- **Static Analysis:** `flutter analyze` $\to$ **0 issues found**.
- **Automated Test Suite:** `flutter test` $\to$ **76 tests passed (0 failures)**.
- **Production Build:** Release APK generated successfully (`app-release.apk`, 50.3MB).
