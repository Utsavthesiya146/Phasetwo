# PhaseTwo — Final Device Test Checklist

**Project:** PhaseTwo Native Mobile Application  
**Package ID:** `ca.phasetwo.phasetwo`  
**Platform Target:** Android & iOS  
**Approved Design:** Option B — PhaseTwo Modern Dynamic  
**Status:** QA & RELEASE READY  

---

## 1. Device Viewport Matrix

| Viewport Profile | Width | Target Devices | Visual Overflow Check | Keyboard Check | Pass / Fail |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Compact Ultra** | 320px | iPhone SE 1, Alcatel, compact Android | 0 overflow pixels | `SingleChildScrollView` scrolls smoothly | **PASS** |
| **Compact Standard** | 360px | Samsung Galaxy A-series, Moto G | 0 overflow pixels | Fields visible above keyboard | **PASS** |
| **Standard iOS** | 393px | iPhone 14 / 15 / 16, iPhone 13 Pro | 0 overflow pixels | iOS Done accessory toolbar supported | **PASS** |
| **Standard Android** | 412px | Google Pixel 7/8/9, Galaxy S23/S24 | 0 overflow pixels | Next/Done IME actions navigate inputs | **PASS** |
| **Large Flagship** | 430px | iPhone 15/16 Pro Max, Pixel Pro XL | 0 overflow pixels | Content centered in max constraints | **PASS** |
| **Tablet** | 768px | Apple iPad (all models), Galaxy Tab | 0 overflow pixels | Auth cards bounded with responsive margins | **PASS** |

---

## 2. Native Authentication Functional Checklist

### 2.1 Candidate Login Screen
- [x] Header displays Option B Navy gradient, Canadian flag badge (`🍁 Experienced Talent Network`).
- [x] Email or phone number input accepts Canadian formatting.
- [x] Password field masks input by default (`••••••••`).
- [x] Show/Hide password toggle flips visibility between plain text and obscured.
- [x] Submitting empty fields triggers instant inline validation without network requests.
- [x] Submitting invalid credentials displays an Option B red feedback banner with dismiss action.
- [x] Tapping "Forgot Password?" navigates directly to native `ForgotPasswordScreen`.
- [x] Tapping "Join PhaseTwo" navigates to native `CandidateSignupScreen`.
- [x] Tapping "Looking to Hire? Employer Login" switches to native `EmployerLoginScreen`.
- [x] Terms of Service and Privacy Policy open in secure external browser.
- [x] Successful authentication displays welcome toast and transitions directly to Option B Dashboard.

### 2.2 Employer Login Screen
- [x] Header displays Option B Navy gradient with Recruiter badge (`🍁 Employer & Recruiter Console`).
- [x] Corporate email input validates `@` and `.` characters.
- [x] Password field toggle operates with accessibility labels.
- [x] Loading state disables the submit button and prevents duplicate submissions.
- [x] Submitting unauthorized credentials shows server failure prompt.
- [x] Tapping "Register Employer" navigates to native `EmployerSignupScreen`.
- [x] Switching between candidate and employer logins works instantaneously.

### 2.3 Candidate Signup Screen
- [x] First Name and Last Name render in responsive dual-column layout.
- [x] Professional Stream dropdown displays full industry list (IT, Finance, Healthcare, etc.).
- [x] Preferred Work Location field accepts Canadian cities and remote preferences.
- [x] Qualification and Experience selectors display standard executive tiers (`10+ year`).
- [x] Date of Birth field allows direct text entry or date picker dialog.
- [x] Password confirmation validates match before submitting.
- [x] Terms and Privacy checkbox is mandatory before registration submit.
- [x] Successful registration shows confirmation banner and directs candidate to sign in.

### 2.4 Employer Signup Screen
- [x] Starter Plan green highlight card indicates PhaseTwo Free Employer Starter Tier ($0 CAD).
- [x] Contact Person Name and Organization Name validate non-empty input.
- [x] Corporate Email Address field validates domain syntax.
- [x] Industry / Primary Domain selector functions without clipping.
- [x] Company Website field supports optional entry.
- [x] Submit button locks during transmission to prevent duplicate registrations.

### 2.5 Forgot Password Screen
- [x] Dedicated clean native interface with Canadian branding.
- [x] Instructions outline the secure reset process.
- [x] Submitting registered email shows success confirmation.

---

## 3. Session & Dashboard Integration Checklist

- [x] Successful login stores session cookie (`ci_session`) in persistent storage.
- [x] Session automatically syncs to `WebViewCookieManager` for webview-assisted sections.
- [x] Bottom navigation bar maintains all 4 tabs (`Home`, `Jobs`, `Candidate`, `Employer`).
- [x] Candidate login lands on candidate features; does not grant recruiter administrative powers.
- [x] Employer login lands on recruiter console; does not grant candidate profile editing powers.
- [x] App restart while authenticated maintains valid session without re-prompting credentials.
- [x] Side drawer "Sign Out" or profile logout destroys session cookies and returns to native Welcome screen.

---

## 4. Mobile Ergonomics & Accessibility

- [x] All touch targets meet minimum 48x48dp guidelines.
- [x] High-contrast text conforms to WCAG 2.1 AA standards.
- [x] Dynamic text scaling (1.5x and 2.0x) does not clip or overflow.
- [x] Physical Android Back Button and iOS swipe-to-pop navigation behave consistently.
- [x] Safe areas (iOS notch, Dynamic Island, Android navigation bars) respect device insets.
