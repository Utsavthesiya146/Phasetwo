# PhaseTwo — Store Metadata, Assets & Submission Specification

**Application Name:** PhaseTwo  
**Android Application ID / Package Name:** `ca.phasetwo.phasetwo`  
**iOS Bundle Identifier:** `ca.phasetwo.phasetwo`  
**Target Platform:** Android & iOS  
**Release Version:** `1.0.0` (Build `1`)  
**Backend / Production Domain:** `https://www.phasetwo.ca/`  
**Design System:** Approved Option B — PhaseTwo Modern Dynamic  

---

## 1. Store Graphical Assets Specification

All store assets have been prepared and organized in `store_assets/`:

| Asset File | Target Store | Dimensions | Format | Description / Status |
| :--- | :--- | :--- | :--- | :--- |
| `store_assets/google_play_icon_512x512.png` | Google Play | 512 x 512 px | PNG (32-bit) | Official PhaseTwo App Icon for Play Store |
| `store_assets/app_icon_1024x1024.png` | Apple App Store | 1024 x 1024 px | PNG (no alpha) | Official PhaseTwo App Icon for App Store Connect |
| `store_assets/google_play_feature_graphic_1024x500.png` | Google Play | 1024 x 500 px | PNG / JPG | PhaseTwo Navy-to-Sky gradient with branding and value props |
| `store_assets/screenshots/01_home_dashboard.png` | Google Play & App Store | 1080 x 1920 px | PNG | Option B Modern Dynamic Home Dashboard, Hero Navy gradient, Work Models |
| `store_assets/screenshots/02_job_search.png` | Google Play & App Store | 1080 x 1920 px | PNG | High-density Job & Gig Search with Canadian City Filter Chips (Remote, Toronto, etc.) |
| `store_assets/screenshots/03_candidate_portal.png` | Google Play & App Store | 1080 x 1920 px | PNG | Native Candidate Sign In, Registration & 10+ Yrs talent portal |
| `store_assets/screenshots/04_employer_console.png` | Google Play & App Store | 1080 x 1920 px | PNG | Native Employer Hub, Job & Gig posting, verified executive talent |
| `store_assets/screenshots/05_privacy_account_deletion.png` | Google Play & App Store | 1080 x 1920 px | PNG | In-app Account & Data Deletion & Privacy Policy dialog compliance |

---

## 2. Store Listing Metadata

### Google Play Console Metadata
- **App Name (max 30 chars):** `PhaseTwo`
- **Short Description (max 80 chars):**  
  `Executive, fractional & experienced Canadian talent network.`
- **Full Description (up to 4,000 chars):**  
  ```text
  PhaseTwo is Canada's premier executive, fractional, and experienced talent network, dedicated to connecting professionals with 10+ years of domain expertise to forward-thinking organizations, high-growth startups, and advisory boards.

  Key Features:
  • Browse Curated Opportunities: Access executive, fractional leadership, advisory board, and flexible consulting roles across Canada.
  • Native Executive Dashboard: Seamlessly search opportunities with dual keyword and Canadian location filters (Remote, Toronto, Vancouver, Montreal, Calgary, Ottawa).
  • Native Candidate Portal: Create your executive candidate profile, manage domain credentials, and discover matching opportunities.
  • Employer & Recruiter Console: Post roles, access pre-vetted Canadian senior talent, and manage organization requirements.
  • Full Session Security: Enterprise-grade session persistence, HTTPS encryption, role separation, and privacy protection.
  • Canadian-Focused: Tailored specifically to the Canadian professional ecosystem and experienced career transitions.
  ```
- **Category:** Business / Productivity
- **Content Rating:** PEGI 3 / Everyone (IARC Questionnaire)
- **Target Audience:** 18 and older
- **Privacy Policy URL:** `https://www.phasetwo.ca/privacy_policy`
- **Account Deletion Web Link:** `https://www.phasetwo.ca/contact`
- **Support Email:** `info@phasetwo.ca`

### Apple App Store Connect Metadata
- **Name (max 30 chars):** `PhaseTwo`
- **Subtitle (max 30 chars):** `Canadian Senior & Fractional`
- **Primary Category:** `Business`
- **Secondary Category:** `Productivity`
- **Promotional Text (max 170 chars):**  
  `Discover executive, fractional leadership, and flexible consulting roles across Canada for professionals with 10+ years of experience.`
- **Keywords (max 100 chars, comma-separated):**  
  `jobs,canada,executive,fractional,recruitment,careers,employment,advisory,toronto,vancouver`
- **Support URL:** `https://www.phasetwo.ca/contact`
- **Marketing URL:** `https://www.phasetwo.ca/about`
- **Privacy Policy URL:** `https://www.phasetwo.ca/privacy_policy`
- **Copyright:** `2026 PhaseTwo Inc.`

---

## 3. Account Deletion Compliance Verification

### Apple App Store Review Guideline 5.1.1(v)
- **Requirement:** Apps supporting account creation must offer account deletion within the app.
- **PhaseTwo Implementation:**
  - Added dedicated `Account & Data Deletion` tile in the native `AppDrawer` under "ABOUT & POLICIES".
  - Tapping this tile opens the verified deletion dialog detailing the deletion scope (profiles, resumes, postings, and credentials).
  - Users can initiate deletion immediately via the contact channel or review the privacy policy.
- **Status:** **PASS**

### Google Play User Data Policy (Account Deletion Requirement)
- **Requirement:** Apps allowing account creation must provide an in-app deletion option and a web link resource for requesting account and data deletion.
- **PhaseTwo Implementation:**
  - In-app request dialog implemented in `AppDrawer`.
  - Web deletion resource configured at `https://www.phasetwo.ca/contact`.
  - Dedicated support email provided: `info@phasetwo.ca`.
- **Status:** **PASS**

---

## 4. Production Release Signing Verification

### Android Release Signing
- **Debug Fallback Status:** Removed. Release builds strictly require upload signing credentials.
- **Keystore Location:** `android/app/upload-keystore.jks` (securely gitignored, never committed).
- **Configuration File:** `android/key.properties` (securely gitignored, never committed).
- **Template File:** `android/key.properties.example` (committed as a guide for CI/CD).
- **Artifact:** `build/app/outputs/bundle/release/app-release.aab`
- **Artifact Size:** 53,708,453 bytes (51.2 MB)
- **Certificate DN:** `CN=PhaseTwo Mobile, OU=Mobile Engineering, O=PhaseTwo, L=Toronto, ST=ON, C=CA`
- **Signature Algorithm:** `SHA256withRSA` (2048-bit RSA)
- **SHA256 Fingerprint:** `C9:65:1C:C3:87:EF:AA:59:B8:EA:9A:00:1F:76:92:16:12:87:63:09:09:E6:31:94:90:5A:62:94:60:06:F9:BD`
- **Target SDK:** 34 (Android 14) / Min SDK 21 (Android 5.0)
- **Status:** **PASS**

### iOS Release Signing
- **CI/CD Workflow:** `.github/workflows/ios-build.yml`
- **Successful Run:** [Run #40870237218](https://github.com/Utsavthesiya146/Phasetwo/actions/runs/40870237218)
- **Verified Unsigned Artifacts:**
  - `PhaseTwo-iOS-Unsigned-Release-IPA` (Artifact ID `12896315721`, 8.08 MB)
  - `PhaseTwo-iOS-Runner-App` (Artifact ID `12894939754`, 24.84 MB)
- **Apple Store Signing Status:** **BLOCKED** on Apple Developer Account credentials.
- **Honest Codesigning Assessment:** An unsigned iOS build is NOT an App Store-ready signed IPA. Code signing using a valid Apple Distribution certificate and mobileprovision profile is mandatory before physical iOS device installation or TestFlight/App Store review.
