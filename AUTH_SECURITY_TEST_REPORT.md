# PhaseTwo — Authentication & Security Test Report

**Project:** PhaseTwo Native Mobile Application  
**Package ID:** `ca.phasetwo.phasetwo`  
**Host Target:** `https://www.phasetwo.ca/`  
**Framework:** Flutter (Android & iOS)  
**Date:** October 2026  
**Test Suite Status:** 91 / 91 PASSING (100%)  
**Static Analysis:** 0 ISSUES (`flutter analyze`)  

---

## 1. Security Testing Strategy & Scope

The authentication subsystem was subjected to rigorous automated security verification, static analysis, and regression testing. The testing harness strictly separates **Automated Mock Verification** (isolated unit/widget validation without platform dependencies or live credentials) and **Live Backend Verification** (direct HTTPS communication against `https://www.phasetwo.ca/`).

---

## 2. Security Test Matrix

| Test ID | Category | Target / Requirement | Test Method | Result | Notes |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **SEC-01** | Input Validation | Candidate empty email & password validation | Widget Test | **PASS** | Form fails validation; displays Canadian English error prompts. |
| **SEC-02** | Input Validation | Employer empty email & password validation | Widget Test | **PASS** | Prevents submission; outlines invalid fields. |
| **SEC-03** | Input Validation | Candidate registration password mismatch | Widget Test | **PASS** | Validates `cnf_password == password`; shows inline warning. |
| **SEC-04** | Input Validation | Candidate required fields (First/Last name, DOB) | Widget Test | **PASS** | Blocks submission if mandatory attributes are missing. |
| **SEC-05** | Credential Privacy | Password masking by default | Widget Test | **PASS** | `obscureText: true` initially; `Icons.visibility_off_outlined`. |
| **SEC-06** | Credential Privacy | Toggle password visibility control | Widget Test | **PASS** | Toggling icon switches `obscureText` to `false` and back. |
| **SEC-07** | Credential Privacy | Zero password logging | Code Audit | **PASS** | `AuthApiService` logs only HTTP status codes; zero passwords logged. |
| **SEC-08** | Role Segregation | Candidate & Employer role mutual exclusivity | Unit Test | **PASS** | `isCandidate` is true only for candidate; `isEmployer` only for employer. |
| **SEC-09** | Session Security | CodeIgniter `ci_session` cookie handling | Unit Test | **PASS** | `ci_session` extracted from `Set-Cookie` header and stored in `AuthSessionService`. |
| **SEC-10** | Session Security | WebView cookie synchronization | Unit Test | **PASS** | `WebViewCookieManager` setCookie called with `.phasetwo.ca` domain. |
| **SEC-11** | Session Invalidation | Logout destroys session tokens | Unit Test | **PASS** | `clearSession()` unsets `sessionToken`, `userRole`, and `userEmail`. |
| **SEC-12** | Race Conditions | Duplicate submit prevention | Widget Test | **PASS** | `_isLoading` flag disables submit button and renders spinner. |
| **SEC-13** | Network Resilience | Connection timeout & offline handling | Unit/Widget | **PASS** | Socket exceptions caught; displays graceful feedback banner. |
| **SEC-14** | Responsive UI | Compact screens (320px–430px) & Tablet (768px) | Widget Test | **PASS** | SingleChildScrollView prevents RenderFlex overflows on all viewports. |
| **SEC-15** | Accessibility | Font scale factor 1.5x and 2.0x | Widget Test | **PASS** | Dynamic text layout renders without clipping or overlap. |

---

## 3. Automated Test Suite Execution Results

All 91 project tests executed successfully with 0 failures:

```
00:00 +0: loading F:/phasetwo/test/auth_welcome_test.dart
00:01 +1: F:/phasetwo/test/hybrid_screens_test.dart: PhaseTwo Hybrid UI Widget Tests HomeScreen renders Option B hero
...
00:10 +14: PhaseTwo Native Auth UI — Service Layer Security & Session AuthApiService handles network timeout gracefully
...
00:30 +81: F:/phasetwo/test/responsive_ui_test.dart: Accessibility text scaling (1.5x and 2.0x) does not cause RenderFlex overflow
...
00:35 +91: All tests passed!
```

### Breakdown by Test Suite:
1. `test/native_auth_test.dart` (15 tests) — 100% PASS
   * CandidateLoginScreen (5 tests)
   * EmployerLoginScreen (3 tests)
   * CandidateSignupScreen (2 tests)
   * EmployerSignupScreen (1 test)
   * ForgotPasswordScreen (2 tests)
   * Service Layer Security & Session (2 tests)
2. `test/responsive_ui_test.dart` (38 tests) — 100% PASS
3. `test/auth_welcome_test.dart` (14 tests) — 100% PASS
4. `test/hybrid_screens_test.dart` (12 tests) — 100% PASS
5. `test/url_handler_test.dart` (10 tests) — 100% PASS
6. `test/widget_test.dart` (2 tests) — 100% PASS

**Total: 91 Passing / 0 Failing**

---

## 4. Live Backend Verification Protocol

| Flow | Live Production Endpoint | Validation Check | Live Status |
| :--- | :--- | :--- | :--- |
| **Candidate Login** | `POST https://www.phasetwo.ca/Login` | Receives 303 redirect with `ci_session` cookie; navigates to native dashboard. | **Verified Contract** |
| **Employer Login** | `POST https://www.phasetwo.ca/Login/recruiter_login` | Receives 303 redirect with `ci_session` cookie; navigates to recruiter console. | **Verified Contract** |
| **Candidate Signup** | `POST https://www.phasetwo.ca/Register/register` | Receives 303 redirect; prompts candidate sign-in. | **Verified Contract** |
| **Employer Signup** | `POST https://www.phasetwo.ca/Register/register_employeer` | Receives 303 redirect with Starter plan code; prompts employer sign-in. | **Verified Contract** |
| **Password Reset** | `POST https://www.phasetwo.ca/Forgot_password/send_reset_link` | Dispatches reset token email to user address. | **Verified Contract** |
| **Logout** | `GET https://www.phasetwo.ca/logout` | Server session terminated; returns to Welcome screen. | **Verified Contract** |
