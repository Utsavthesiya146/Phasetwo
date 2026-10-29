# PHASETWO — FINAL ANDROID DEVICE TEST PROTOCOL
**Project:** PhaseTwo Flutter Mobile App  
**Package ID:** `ca.phasetwo.phasetwo`  
**Host Target:** `https://www.phasetwo.ca/`  
**Build Artifact:** `build\app\outputs\flutter-apk\app-release.apk` (50.3 MB)  
**Date:** October 2026  
**Auditor:** Mobile QA Specialist & Android Deployment Engineer

---

## 1. Release APK Installation Instructions

To install the verified release APK onto any physical Android device or emulator:

1. **Connect device via USB** and enable USB Debugging in Developer Options.
2. **Execute via Terminal / PowerShell:**
   ```powershell
   adb install -r F:\phasetwo\build\app\outputs\flutter-apk\app-release.apk
   ```
3. Alternatively, copy `app-release.apk` directly to the device storage and tap to install.

---

## 2. Real-Device Verification Checklist & Acceptance Protocol

The following step-by-step verification plan is ready for execution on a physical device. Each test case indicates its automated verification status and real-device testing readiness:

| Case ID | Verification Scenario | Expected Outcome | Automated Test Status | Device Test Status |
|---|---|---|---|---|
| **TC-01** | **First Launch / Clean Install** | App launches with branded splash (`#0F2B46` gradient), checks session, and smoothly displays `AuthWelcomeScreen`. | **PASSED** | **READY FOR DEVICE RUN** |
| **TC-02** | **Candidate Login Button** | Tapping "Candidate Login" opens the in-app WebView directly to `https://www.phasetwo.ca/login` showing email & password input fields (NOT the homepage). | **PASSED** | **READY FOR DEVICE RUN** |
| **TC-03** | **Employer Login Button** | Tapping "Employer Login" opens the in-app WebView directly to `https://www.phasetwo.ca/recruiter_login` showing company email & password input fields (NOT the homepage). | **PASSED** | **READY FOR DEVICE RUN** |
| **TC-04** | **Candidate Registration** | Tapping "Candidate Sign Up" opens `https://www.phasetwo.ca/register` with candidate registration fields. | **PASSED** | **READY FOR DEVICE RUN** |
| **TC-05** | **Employer Registration** | Tapping "Employer Registration" opens `https://www.phasetwo.ca/recruiter_register` with company registration fields. | **PASSED** | **READY FOR DEVICE RUN** |
| **TC-06** | **Guest Exploration** | Tapping "Explore Platform as Guest" smoothly transitions to Option B native `HomeScreen` without requiring credentials. | **PASSED** | **READY FOR DEVICE RUN** |
| **TC-07** | **Failed Login Attempt** | Entering invalid credentials on `/login` or `/recruiter_login` keeps the user inside the WebView showing the website's real flash error (e.g. "Invalid Email or Password"). Does NOT transition to native dashboard. | **PASSED** | **READY FOR DEVICE RUN** |
| **TC-08** | **Successful Candidate Authentication** | Submitting valid candidate credentials completes web login, detects DOM logout signal, stores session, and transitions to native Option B dashboard with "Candidate session verified" feedback. | **PASSED (Mocked Signal)** | **BLOCKED (Requires Live User Credentials)** |
| **TC-09** | **Successful Employer Authentication** | Submitting valid recruiter credentials completes web login, detects employer route/DOM signal, stores session, and transitions to native Option B dashboard with "Employer session verified" feedback. | **PASSED (Mocked Signal)** | **BLOCKED (Requires Live User Credentials)** |
| **TC-10** | **Candidate Resume Upload (<input type="file">)** | Tapping "Upload Resume" / "Choose File" on candidate registration or profile launches Android's system document picker without crashing or auto-dismissing. | **PASSED (Code Audit)** | **READY FOR DEVICE RUN** |
| **TC-11** | **Four-Tab Bottom Navigation** | Tapping `Home`, `Jobs`, `Candidate`, `Employer` switches native views immediately without layout shifts or text truncation. | **PASSED (5 screen widths)** | **READY FOR DEVICE RUN** |
| **TC-12** | **Back Button Behavior** | Pressing back inside WebView navigates web history; pressing back at web history root closes WebView and returns to native screen; pressing back on Home tab prompts "Exit PhaseTwo?". | **PASSED** | **READY FOR DEVICE RUN** |
| **TC-13** | **Sign Out / Logout** | Selecting "Sign Out" from Drawer prompts confirmation dialog, executes `/logout`, verifies session clearance, and returns to `AuthWelcomeScreen`. | **PASSED** | **READY FOR DEVICE RUN** |
| **TC-14** | **App Restart Session Restoration** | Killing the app and reopening within 2 hours restores the authenticated native dashboard directly without showing the Welcome screen. | **PASSED** | **READY FOR DEVICE RUN** |
| **TC-15** | **Session Expiry Restoration** | Reopening the app after $>2$ hours clears local session state and opens `AuthWelcomeScreen`. | **PASSED** | **READY FOR DEVICE RUN** |

---

## 3. Important Operational Notes for Tester

* **Live Credentials Test Notice:** Because production website credentials are confidential to PhaseTwo users and cannot be fabricated, live authentication tests (TC-08 & TC-09) must be conducted with authorized client test accounts on a real device.
* **No Database or Backend Changes:** The application communicates directly with `https://www.phasetwo.ca/` using standard HTTPS cookies (`ci_session`) without intermediate proxy servers.
* **Release Artifact Location:** The installable binary is located at:
  ```
  F:\phasetwo\build\app\outputs\flutter-apk\app-release.apk
  ```
