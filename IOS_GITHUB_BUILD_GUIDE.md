# PhaseTwo — iOS GitHub Actions Build & TestFlight Guide

**Project:** PhaseTwo Native Mobile Application  
**Bundle ID:** `ca.phasetwo.phasetwo`  
**Host Environment:** GitHub Actions macOS Runner (`macos-14`, Apple Silicon)  
**Target:** iOS 15.0+  
**Workflow File:** `.github/workflows/ios-build.yml`  

---

## 1. Overview

Because the local development workstation operates on Windows, iOS builds, archives, signing, and TestFlight deployments are automated using **GitHub Actions on Apple Silicon macOS runners (`macos-14`)**.

This document provides complete instructions for configuring required Apple credentials, GitHub repository secrets, triggering builds, and managing TestFlight releases.

---

## 2. GitHub Actions CI/CD Architecture

The `.github/workflows/ios-build.yml` pipeline implements a two-tier build process:

```
                  ┌────────────────────────────────────────┐
                  │ Push / PR to main or Workflow Dispatch │
                  └───────────────────┬────────────────────┘
                                      │
                         ┌────────────▼───────────┐
                         │ macOS-14 Runner Setup  │
                         │ Flutter Stable Channel │
                         └────────────┬───────────┘
                                      │
                   ┌──────────────────┴──────────────────┐
                   │                                     │
         ┌─────────▼─────────┐                 ┌─────────▼─────────┐
         │  flutter analyze  │                 │   flutter test    │
         │  (0 lint errors)  │                 │ (91 tests passed) │
         └─────────┬─────────┘                 └─────────┬─────────┘
                   │                                     │
                   └──────────────────┬──────────────────┘
                                      │
                         ┌────────────▼───────────┐
                         │   CocoaPods Install    │
                         │    (iOS Pods Cache)    │
                         └────────────┬───────────┘
                                      │
                         ┌────────────▼───────────┐
                         │  flutter build ios     │
                         │ (--release --no-sign)  │
                         └────────────┬───────────┘
                                      │
                   ┌──────────────────┴──────────────────┐
                   │                                     │
        ┌──────────▼──────────┐              ┌───────────▼───────────┐
        │  Package Unsigned   │              │ Are Apple Signing     │
        │  PhaseTwo-unsigned  │              │ Secrets Configured?   │
        │        .ipa         │              └───────────┬───────────┘
        └──────────┬──────────┘                          │
                   │                             ┌───────┴───────┐
                   │                            YES              NO
                   │                             │               │
                   │                   ┌─────────▼─────────┐     └► [Skip Signing]
                   │                   │  Import Keychain  │
                   │                   │ flutter build ipa │
                   │                   └─────────┬─────────┘
                   │                             │
                   │                   ┌─────────▼─────────┐
                   │                   │ Optional Upload:  │
                   │                   │  Apple TestFlight │
                   │                   └─────────┬─────────┘
                   │                             │
                   └──────────────────┬──────────┘
                                      │
                        ┌─────────────▼────────────┐
                        │ Upload GitHub Artifacts  │
                        │ (IPA / Build Diagnostics)│
                        └──────────────────────────┘
```

---

## 3. Required GitHub Repository Secrets

Navigate to **GitHub Repository → Settings → Secrets and variables → Actions → New repository secret**.

| Secret Name | Description | Example / Format |
| :--- | :--- | :--- |
| `APPLE_CERTIFICATE_BASE64` | Apple Distribution Certificate (`.p12`) encoded in Base64 | Base64 string |
| `APPLE_CERTIFICATE_PASSWORD` | Password protecting the exported `.p12` certificate file | Plain text password |
| `APPLE_PROVISIONING_PROFILE_BASE64` | App Store Distribution Provisioning Profile (`.mobileprovision`) in Base64 | Base64 string |
| `KEYCHAIN_PASSWORD` | Temporary password for runner keychain | Random alphanumeric string |
| `APP_STORE_CONNECT_API_KEY` | *(Optional for TestFlight)* App Store Connect API Key (`.p8`) in Base64 | Base64 string |
| `APP_STORE_CONNECT_KEY_ID` | *(Optional for TestFlight)* 10-character Key ID | e.g. `2X9R4ABCD3` |
| `APP_STORE_CONNECT_ISSUER_ID` | *(Optional for TestFlight)* App Store Connect Issuer UUID | e.g. `57246542-96fe-1a63-e053-0824d011072a` |

---

## 4. How to Generate Required Apple Signing Files

### 4.1 Exporting the Distribution Certificate (.p12)
1. On a Mac with access to the Apple Developer account, open **Keychain Access**.
2. Select **My Certificates** in the sidebar.
3. Locate **Apple Distribution: [Organization Name] (Team ID)**.
4. Right-click and choose **Export "Apple Distribution: ... "**.
5. Select format **Personal Information Exchange (.p12)**.
6. Provide an export password (save this as `APPLE_CERTIFICATE_PASSWORD`).
7. Convert to Base64:
   * **On Windows (PowerShell):**
     ```powershell
     [Convert]::ToBase64String([IO.File]::ReadAllBytes('dist_certificate.p12')) | Set-Clipboard
     ```
   * **On macOS / Linux:**
     ```bash
     base64 -i dist_certificate.p12 | pbcopy
     ```
8. Paste into GitHub Secret `APPLE_CERTIFICATE_BASE64`.

### 4.2 Generating the Provisioning Profile (.mobileprovision)
1. Sign in to [developer.apple.com](https://developer.apple.com/account).
2. Go to **Certificates, Identifiers & Profiles → Profiles → Generate a Profile**.
3. Select **App Store** (under Distribution).
4. Select App ID: `ca.phasetwo.phasetwo`.
5. Select the Apple Distribution Certificate generated in step 4.1.
6. Enter Profile Name (e.g., `PhaseTwo_AppStore_Profile`).
7. Download the `.mobileprovision` file.
8. Convert to Base64:
   * **On Windows (PowerShell):**
     ```powershell
     [Convert]::ToBase64String([IO.File]::ReadAllBytes('PhaseTwo_AppStore_Profile.mobileprovision')) | Set-Clipboard
     ```
   * **On macOS / Linux:**
     ```bash
     base64 -i PhaseTwo_AppStore_Profile.mobileprovision | pbcopy
     ```
9. Paste into GitHub Secret `APPLE_PROVISIONING_PROFILE_BASE64`.

### 4.3 App Store Connect API Key (for automated TestFlight delivery)
1. Sign in to [appstoreconnect.apple.com](https://appstoreconnect.apple.com/).
2. Navigate to **Users and Access → Integrations → App Store Connect API**.
3. Click **+** to generate a new key.
   * Name: `PhaseTwo-CI-CD`
   * Access: **App Manager** or **Admin**
4. Copy the **Key ID** (`APP_STORE_CONNECT_KEY_ID`).
5. Copy the **Issuer ID** (`APP_STORE_CONNECT_ISSUER_ID`).
6. Download the private key file (`AuthKey_XXXXXXXXXX.p8`). Note: Apple only allows downloading this once!
7. Convert the `.p8` file to Base64 and save as `APP_STORE_CONNECT_API_KEY`.

---

## 5. Triggering iOS Builds

### 5.1 Automatic Trigger
Any push or pull request to `main` automatically triggers code checkout, dependency resolution, static analysis (`flutter analyze`), unit/widget tests (`flutter test`), CocoaPods setup, and unsigned compilation validation.

### 5.2 Manual TestFlight Release Trigger
1. Go to **GitHub Repository → Actions**.
2. Select **PhaseTwo iOS Release & TestFlight CI/CD**.
3. Click **Run workflow**.
4. Check **Upload signed build to Apple TestFlight**.
5. Click **Run workflow**.

---

## 6. Accessing Build Artifacts

1. When the workflow completes, open the workflow run details.
2. Under **Artifacts** at the bottom of the summary page:
   * **`PhaseTwo-iOS-Unsigned-Release`**: Downloadable `.ipa` payload containing `Runner.app` for architecture inspection and simulator verification.
   * **`PhaseTwo-iOS-Production-Signed-IPA`**: Production signed `.ipa` ready for manual upload via Apple Transporter or verification.
3. TestFlight builds appear in App Store Connect under the **TestFlight** tab within 10–15 minutes after automated processing and asset compilation.
