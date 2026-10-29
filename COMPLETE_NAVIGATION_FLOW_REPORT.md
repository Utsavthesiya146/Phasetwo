# PHASETWO — COMPLETE NAVIGATION FLOW REPORT
**Project:** PhaseTwo Flutter Mobile Application  
**Package ID:** `ca.phasetwo.phasetwo`  
**Production Host:** `https://www.phasetwo.ca/`  
**Date:** October 2026  
**Auditor:** Senior Flutter Architect, Mobile UX Engineer & Navigation Specialist

---

## 1. System Architecture & Lifecycle Model

The PhaseTwo mobile application uses a **deterministic dual-runtime navigation architecture**:
1. **Primary Runtime:** Client-approved **Option B Modern Dynamic UI** rendered in native Flutter widgets.
2. **Web Runtime:** Single persistent, offstage-managed `PhaseTwoWebViewScreen` that loads live website-dependent workflows (forms, applications, portal consoles) without reloading or creating duplicate shells.

```mermaid
graph TD
    A[App Launch] --> B[Splash Screen]
    B -->|Check AuthSessionService| C{Authenticated?}
    C -->|No / Expired| D[Native AuthWelcomeScreen]
    C -->|Yes / Active Session| E[Option B Native Dashboard]
    
    D -->|Tap Candidate Login| F[In-App WebView: /login]
    D -->|Tap Employer Login| G[In-App WebView: /recruiter_login]
    D -->|Tap Candidate Sign Up| H[In-App WebView: /register]
    D -->|Tap Employer Sign Up| I[In-App WebView: /recruiter_register]
    D -->|Explore as Guest| E
    
    F -->|Successful Auth Signal| J[AuthSessionService.setVerifiedSession]
    G -->|Successful Auth Signal| J
    J --> E
    
    F -->|Failed Auth| K[Stay on WebView / Display Validation Error]
    G -->|Failed Auth| K
    
    E -->|Bottom Nav| L[Tabs: Home | Jobs | Candidate | Employer]
    E -->|Open Drawer / Tile| M[Feature Deep Links]
```

---

## 2. End-to-End Navigation Matrix

| Entry Point | Action Triggered | Target URL / Screen | Runtime | Lifecycle & Return Behavior |
|---|---|---|---|---|
| **App Startup** | App Opens | `SplashScreen` $\to$ `AuthWelcomeScreen` | Native Flutter | If `ci_session` expired or no local session, shows Welcome. |
| **Welcome Screen** | Candidate Login Button | `https://www.phasetwo.ca/login` | In-App WebView | Queued & loaded. On auth verified $\to$ Transitions to Native Home. |
| **Welcome Screen** | Employer Login Button | `https://www.phasetwo.ca/recruiter_login` | In-App WebView | Queued & loaded. On auth verified $\to$ Transitions to Native Home. |
| **Welcome Screen** | Candidate Sign Up | `https://www.phasetwo.ca/register` | In-App WebView | Direct registration form. Back/Close returns to Welcome. |
| **Welcome Screen** | Employer Registration | `https://www.phasetwo.ca/recruiter_register` | In-App WebView | Direct registration form. Back/Close returns to Welcome. |
| **Welcome Screen** | Explore as Guest | Native `HomeScreen` (Tab 0) | Native Flutter | Activates guest mode. Displays 4-tab Option B UI. |
| **Bottom Tab 0** | Home Tab Selection | `HomeScreen` | Native Flutter | Active tab = 0. Hides WebView (`offstage: true`). |
| **Bottom Tab 1** | Jobs Tab Selection | `JobsScreen` | Native Flutter | Active tab = 1. Live search inputs and quick category chips. |
| **Bottom Tab 2** | Candidate Tab Selection | `CandidateSectionScreen` | Native Flutter | Active tab = 2. Option B Candidate Portal cards & CTAs. |
| **Bottom Tab 3** | Employer Tab Selection | `EmployerSectionScreen` | Native Flutter | Active tab = 3. Recruiter console, pricing, post-job CTAs. |
| **Job Search UI** | Keyword / Search Submission | `https://www.phasetwo.ca/browse_jobs?search=...` | In-App WebView | Opens filtered live results inside persistent WebView. |
| **Live Gigs** | Drawer / Hero Action | `https://www.phasetwo.ca/gigs` | In-App WebView | Displays live gigs portal with application buttons. |
| **Post a Role** | Employer CTA / Drawer | `https://www.phasetwo.ca/company/New_job_post` | In-App WebView | Opens job submission form inside persistent WebView. |
| **Pricing & Plans**| Employer CTA / Drawer | `https://www.phasetwo.ca/pricing` | In-App WebView | Full pricing tiers table and checkout actions. |
| **Career Assistance**| Candidate CTA / Drawer | `https://www.phasetwo.ca/Assistance` | In-App WebView | Executive coaching and resume review request form. |
| **Candidate Dashboard**| Drawer / Portal Action | `https://www.phasetwo.ca/candidate/dashboard` | In-App WebView | Candidate applications, bookmarks, profile settings. |
| **Employer Dashboard** | Drawer / Portal Action | `https://www.phasetwo.ca/company/dashboard` | In-App WebView | Recruiter posted jobs, applicant review console. |
| **Password Reset**| Login Page Link | `https://www.phasetwo.ca/Forgot_password` | In-App WebView | Account recovery email dispatcher. |
| **About / FAQ** | Drawer Actions | `https://www.phasetwo.ca/about`, `/faq` | In-App WebView | Branded platform informational pages. |
| **Contact Support**| Drawer Action | `https://www.phasetwo.ca/contact` | In-App WebView | Support message submission. |
| **Terms / Privacy**| Drawer Actions | `https://www.phasetwo.ca/terms_conditions`, `/privacy_policy` | In-App WebView | Legal agreements and privacy statement. |
| **Sign Out** | Drawer Logout Action | `AuthSessionService.clearSession()` + `/logout` | Native $\to$ Web | Clears local state, triggers server logout, returns to Welcome. |

---

## 3. Back Button & Dialog Hierarchy

The back navigation handles 4 strict priority layers via `PopScope`:

```
User Presses Hardware Back / Gesture
               │
               ▼
[Layer 1] Is Drawer Open? ──► YES ──► Close Drawer (Navigator.pop)
               │ NO
               ▼
[Layer 2] Is WebView Active? ──► YES ──► Can WebView Go Back? ──► YES ──► WebView.goBack()
               │                                                      NO
               │ NO                                                   ▼
               │                                                Close WebView (Return to Native UI)
               ▼
[Layer 3] On Non-Home Tab (1, 2, 3)? ──► YES ──► Select Tab 0 (Home)
               │ NO
               ▼
[Layer 4] On Home Tab (Tab 0) ──► Show "Exit PhaseTwo?" Confirmation Dialog ──► Exit / Cancel
```

---

## 4. In-App vs. External Launch Rules

All internal routes stay inside the app. External handing is strictly limited to:
* **System Schemes:** `mailto:`, `tel:`, `sms:`, `whatsapp:`.
* **Downloadable Assets:** `.pdf`, `.doc`, `.docx`, `.xls`, `.xlsx`, `.zip` (opened in Android/iOS Download Manager).
* **Social Media:** LinkedIn, Facebook, Instagram, Twitter/X profiles (opened in external browser or native app).

---

## 5. Session Synchronization & Restart Verification

1. **Persistent Session Storage:** Stored securely in `SharedPreferences` with timestamp and role.
2. **Session Validity Window:** 2 hours (`sessionTimeout = Duration(hours: 2)`), strictly aligned with Hostinger CodeIgniter server's `ci_session` lifetime.
3. **App Launch Lifecycle:**
   - `SplashScreen` invokes `AuthSessionService.instance.init()`.
   - If session is active ($\le 2$ hours), restores `MainShellScreen(initialAuthenticated: true)`.
   - If session is expired or missing, opens `MainShellScreen(initialAuthenticated: false)` displaying `AuthWelcomeScreen`.
