# PhaseTwo — Native Mobile Application (Android & iOS)

[![Flutter CI/CD](https://github.com/Utsavthesiya146/Phasetwo/actions/workflows/ios-build.yml/badge.svg)](https://github.com/Utsavthesiya146/Phasetwo/actions/workflows/ios-build.yml)
[![Tests Passing](https://img.shields.io/badge/Tests-91%20Passing-brightgreen.svg)](https://github.com/Utsavthesiya146/Phasetwo)
[![Analyze Clean](https://img.shields.io/badge/Flutter%20Analyze-0%20Issues-brightgreen.svg)](https://github.com/Utsavthesiya146/Phasetwo)
[![Platforms](https://img.shields.io/badge/Platforms-Android%20%7C%20iOS-blue.svg)](https://github.com/Utsavthesiya146/Phasetwo)

PhaseTwo is Canada's premier executive, fractional leadership, and experienced talent network (10+ years), connecting senior leaders to innovative organizations, startups, and advisory boards across Canada.

This repository contains the complete cross-platform Flutter codebase for Android and iOS, built with the client-approved **Option B — PhaseTwo Modern Dynamic** user interface.

---

## 🚀 Key Features

* **Approved Option B Modern Dynamic Design**: Signature navy/blue gradient hero banners (`#0F2B46` to `#0284C7`), rounded cards, crisp typography, and touch ergonomics meeting WCAG 2.1 AA standards.
* **100% Native Authentication Screens**:
  * Candidate Sign In (`CandidateLoginScreen`)
  * Recruiter / Employer Sign In (`EmployerLoginScreen`)
  * Candidate Registration (`CandidateSignupScreen`)
  * Employer Registration with Free Starter Tier (`EmployerSignupScreen`)
  * Password Recovery (`ForgotPasswordScreen`)
* **Real Production Backend Integration**: Connects directly to the live CodeIgniter backend (`https://www.phasetwo.ca/`), capturing `ci_session` cookies and automatically synchronizing authentication sessions with `WebViewCookieManager` for contextual web features.
* **Equal 4-Tab Bottom Navigation**: Fixed, responsive tab bar with zero label overlap across 320px, 360px, 393px, 412px, 430px, and 768px tablet viewports (`Home`, `Jobs`, `Candidate`, `Employer`).
* **Multi-Screen & Accessibility Ready**: Validated against dynamic text scaling (1.5x and 2.0x), Android back gestures, and iOS swipe-to-pop navigation.

---

## 🏗️ Project Architecture

```
lib/
├── config/
│   └── app_config.dart                  # Branding tokens, URLs, endpoints, themes
├── screens/
│   ├── auth/                            # Native Authentication Screens
│   │   ├── candidate_login_screen.dart
│   │   ├── candidate_signup_screen.dart
│   │   ├── employer_login_screen.dart
│   │   ├── employer_signup_screen.dart
│   │   └── forgot_password_screen.dart
│   ├── auth_welcome_screen.dart         # Native Welcome & Role Selection
│   ├── candidate_section_screen.dart    # Tab 2: Candidate Hub
│   ├── employer_section_screen.dart     # Tab 3: Employer Hub
│   ├── home_screen.dart                 # Tab 0: Modern Dynamic Dashboard
│   ├── jobs_screen.dart                 # Tab 1: Job Search & Filters
│   ├── main_shell.dart                  # Bottom Nav Shell & Session Bridge
│   ├── splash_screen.dart               # Animated Launch Screen
│   └── webview_screen.dart              # Contextual In-App Browser Integration
├── services/
│   ├── auth_api_service.dart            # Native HTTP CodeIgniter Client
│   ├── auth_session_service.dart        # Session & Cookie Persistence
│   ├── network_service.dart             # Connectivity & Offline Handler
│   └── url_handler_service.dart         # URL Routing & Scheme Classifier
└── widgets/
    ├── app_drawer.dart                  # Native Side Navigation Drawer
    ├── auth/auth_components.dart        # Reusable Option B Auth Widgets
    ├── bottom_nav_bar.dart              # Equal-width Custom Bottom Navigation
    └── custom_header.dart               # Responsive App Header
```

---

## 🛠️ Getting Started & Local Development

### Prerequisites
* Flutter SDK (3.24+ / 3.47+ stable)
* Android Studio / Xcode 15+
* Java 17+

### Setup
```bash
# Clone the repository
git clone https://github.com/Utsavthesiya146/Phasetwo.git
cd Phasetwo

# Install dependencies
flutter pub get

# Run static analysis
flutter analyze

# Run complete test suite (91 automated tests)
flutter test
```

---

## 📦 Building Releases

### Android Releases (Windows / macOS / Linux)

```bash
# Build Release APK
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

# Build Google Play App Bundle (AAB)
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS Releases (Automated via GitHub Actions)
iOS builds are automated using GitHub Actions (`.github/workflows/ios-build.yml`) on macOS runners.
Refer to [IOS_GITHUB_BUILD_GUIDE.md](IOS_GITHUB_BUILD_GUIDE.md) for certificate setup, repository secrets, and TestFlight delivery instructions.

---

## 📋 Documentation & Reports

* [AUTH_BACKEND_COMPATIBILITY_REPORT.md](AUTH_BACKEND_COMPATIBILITY_REPORT.md) — Backend endpoints, payload schemas, and session mechanics.
* [NATIVE_AUTH_IMPLEMENTATION_REPORT.md](NATIVE_AUTH_IMPLEMENTATION_REPORT.md) — Native auth UI architecture and Option B component specifications.
* [AUTH_SECURITY_TEST_REPORT.md](AUTH_SECURITY_TEST_REPORT.md) — 15-point security matrix and 91/91 test results.
* [IOS_GITHUB_BUILD_GUIDE.md](IOS_GITHUB_BUILD_GUIDE.md) — Complete GitHub Actions iOS build and TestFlight setup.
* [PLAYSTORE_APPSTORE_SUBMISSION_CHECKLIST.md](PLAYSTORE_APPSTORE_SUBMISSION_CHECKLIST.md) — Step-by-step submission guide for Google Play and Apple App Store.
* [FINAL_DEVICE_TEST_CHECKLIST.md](FINAL_DEVICE_TEST_CHECKLIST.md) — Multi-device viewport and layout testing matrix.
* [PHASETWO_FINAL_RELEASE_REPORT.md](PHASETWO_FINAL_RELEASE_REPORT.md) — Complete executive release audit.
