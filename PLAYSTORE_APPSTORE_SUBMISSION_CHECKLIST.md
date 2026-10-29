# PhaseTwo — Google Play Store & Apple App Store Submission Checklist

**Application Name:** PhaseTwo  
**Android Application ID:** `ca.phasetwo.phasetwo`  
**iOS Bundle Identifier:** `ca.phasetwo.phasetwo`  
**Current Release Version:** `1.0.0` (Build `1`)  
**Target Backend:** `https://www.phasetwo.ca/`  
**Date:** October 2026  

---

## 1. Google Play Console Checklist

### 1.1 Developer Account & App Creation
- [ ] Active Google Play Developer Account ($25 one-time registration fee).
- [ ] Create App → Name: **PhaseTwo** | Default Language: **English (Canada) - en-CA** | App Type: **App** | Free or Paid: **Free**.
- [ ] Accept Developer Program Policies and US export laws.

### 1.2 Store Listing Metadata
- **App Name (30 characters):** `PhaseTwo`
- **Short Description (80 characters):**  
  `Executive, fractional & experienced Canadian talent network.`
- **Full Description (up to 4,000 characters):**  
  ```
  PhaseTwo is Canada's premier executive, fractional, and experienced talent network, dedicated to connecting professionals with 10+ years of domain expertise to forward-thinking organizations, high-growth startups, and advisory boards.

  Key Features:
  • Browse Curated Opportunities: Access executive, fractional leadership, advisory board, and flexible consulting roles across Canada.
  • Native Executive Dashboard: Seamlessly search opportunities with dual keyword and Canadian location filters (Remote, Toronto, Vancouver, Montreal, Calgary, Ottawa).
  • Native Candidate Portal: Create your executive candidate profile, manage domain credentials, and discover matching opportunities.
  • Employer & Recruiter Console: Post roles, access pre-vetted Canadian senior talent, and manage organization requirements.
  • Full Session Security: Enterprise-grade session persistence, HTTPS encryption, role separation, and privacy protection.
  • Canadian-Focused: Tailored specifically to the Canadian professional ecosystem and experienced career transitions.
  ```

### 1.3 Graphic Assets
- [ ] **App Icon:** 512 x 512 px PNG (32-bit, transparent or white background, max 1024 KB).
- [ ] **Feature Graphic:** 1024 x 500 px JPG or PNG (no transparency).
- [ ] **Phone Screenshots (minimum 4):**
  - Modern Dynamic Home Dashboard
  - Job Search with Canadian Location Chips
  - Native Candidate Portal & Sign In
  - Native Employer Hub & Console
  - Aspect ratio 9:16 (e.g., 1080 x 2400 px or 1080 x 1920 px).
- [ ] **7-Inch Tablet Screenshots:** At least 1 screenshot.
- [ ] **10-Inch Tablet Screenshots:** At least 1 screenshot.

### 1.4 Policy & Content Declarations
- [ ] **Privacy Policy URL:** `https://www.phasetwo.ca/privacy_policy`
- [ ] **App Access:** "All functionality is available without restrictions" OR provide demo credentials:
  - Role: Candidate Demo / Employer Demo
- [ ] **Ads:** Select "No, my app does not contain ads".
- [ ] **Content Ratings:** Complete IARC questionnaire:
  - Category: Reference, News or Educational / Employment.
  - Expected Rating: **PEGI 3 / Everyone**.
- [ ] **Target Audience:** Select **18 and older**.
- [ ] **Data Safety Form:**
  - **Personal Info:** Name, Email address, Phone number (collected for account creation & job applications).
  - **Financial Info:** None collected directly in-app.
  - **Data Encryption:** All data encrypted in transit using HTTPS (TLS 1.2/1.3).
  - **Data Deletion:** Provide link or email for account deletion requests (`support@phasetwo.ca`).
- [ ] **Government Apps:** Select "No".
- [ ] **Financial Features:** Select "My app doesn't provide any financial features".

### 1.5 App Release Tracks
- [ ] **Artifact:** `build/app/outputs/bundle/release/app-release.aab`.
- [ ] **Release Name:** `1.0.0 (1) - PhaseTwo Native Release`.
- [ ] **Release Notes:**
  ```
  Welcome to PhaseTwo 1.0.0!
  - Full native authentication UI for Candidates and Employers.
  - Option B Modern Dynamic executive dashboard.
  - High-density job search with Canadian city filters.
  - Real backend CodeIgniter session synchronization.
  ```
- [ ] Rollout to **Internal Testing** → Verify on physical test device → Promote to **Closed Testing / Production**.

---

## 2. Apple App Store Submission Checklist

### 2.1 Apple Developer Account & App Identifier
- [ ] Active Apple Developer Program enrollment ($99 USD/year).
- [ ] Registered App ID in developer portal: `ca.phasetwo.phasetwo`.
- [ ] App created in [App Store Connect](https://appstoreconnect.apple.com/):
  - Primary Language: **English (Canada)**
  - Bundle ID: `ca.phasetwo.phasetwo`
  - SKU: `PHASETWO-IOS-001`
  - User Access: Full Access

### 2.2 App Store Product Page Information
- **App Name (30 characters):** `PhaseTwo`
- **Subtitle (30 characters):** `Canadian Senior & Fractional`
- **Primary Category:** `Business`
- **Secondary Category:** `Productivity`
- **Promotional Text (170 characters):**  
  `Discover executive, fractional leadership, and flexible consulting roles across Canada for professionals with 10+ years of experience.`
- **Keywords (100 characters max, comma-separated):**  
  `jobs,canada,executive,fractional,recruitment,careers,employment,advisory,toronto,vancouver`
- **Support URL:** `https://www.phasetwo.ca/contact`
- **Marketing URL:** `https://www.phasetwo.ca/about`
- **Privacy Policy URL:** `https://www.phasetwo.ca/privacy_policy`

### 2.3 Required iOS Screenshots
- [ ] **6.7" Display (iPhone 15 Pro Max / 16 Pro Max):** 1290 x 2796 px (minimum 3).
- [ ] **6.5" Display (iPhone 11 Pro Max / XS Max):** 1242 x 2688 px (minimum 3).
- [ ] **12.9" iPad Display (6th Gen):** 2048 x 2732 px (if iPad support enabled).

### 2.4 App Privacy Questionnaire (Nutrition Labels)
- [ ] Data Collection: **Yes, we collect data from this app**.
- [ ] Types of Data Collected:
  - **Contact Info:** Name, Email Address, Phone Number (used for App Functionality & Account Management; linked to identity).
  - **User Content:** Profile info, job search criteria, resume information (used for App Functionality; linked to identity).
  - **Identifiers:** User ID (linked to identity).
- [ ] Tracking: Select **No, we do not use data for tracking purposes across other apps and websites**.

### 2.5 App Review Information
- [ ] **Sign-in Required:** Yes.
- [ ] **Demo Account:**
  - Candidate: `candidate.demo@phasetwo.ca` / `DemoPhaseTwo2026!`
  - Employer: `recruiter.demo@phasetwo.ca` / `DemoPhaseTwo2026!`
- [ ] **Notes for Reviewer:**  
  `PhaseTwo provides an experienced Canadian professional network. Authentication is fully native and communicates with our live production backend.`
- [ ] **Contact Information:** Full name, phone number, and email of release manager.

### 2.6 Build Delivery & TestFlight
- [ ] Automated build via GitHub Actions workflow (`.github/workflows/ios-build.yml`).
- [ ] Verify build appearance in TestFlight tab within 15 minutes.
- [ ] Complete "Export Compliance Information" (Select **No** for non-standard encryption; standard HTTPS/TLS is exempt under EAR 740.17).
- [ ] Add internal testers and verify on physical iPhone / iPad.
- [ ] Select build on App Store version page and click **Submit for Review**.
