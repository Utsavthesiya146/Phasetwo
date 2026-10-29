# PhaseTwo — Auth Backend Compatibility Report

**Project:** PhaseTwo Native Mobile Application  
**Package ID:** `ca.phasetwo.phasetwo`  
**Host Environment:** `https://www.phasetwo.ca/`  
**Backend Framework:** CodeIgniter (PHP) with Session Driver  
**Date:** October 2026  
**Status:** FULLY COMPATIBLE & VERIFIED  

---

## 1. Executive Summary

This report documents the authentication contract, endpoints, payload structures, session mechanics, and integration architecture connecting the PhaseTwo native Flutter mobile application with the live production CodeIgniter backend (`https://www.phasetwo.ca/`).

Rather than opening web forms within an embedded WebView, the mobile application uses native Dart HTTP networking with full cookie jar and session persistence (`AuthApiService`), automatically synchronizing authenticated state with platform web cookies (`WebViewCookieManager`) for seamless contextual web operations.

---

## 2. Production Endpoint Specifications

### 2.1 Candidate Login
* **URL:** `https://www.phasetwo.ca/Login`
* **HTTP Method:** `POST`
* **Content-Type:** `application/x-www-form-urlencoded`
* **Form Fields:**
  * `email` (string, required): Candidate's registered email address or phone number.
  * `password` (string, required): Account password.
* **Server Response Contract:**
  * **Success:** HTTP `303 See Other` redirect to `https://www.phasetwo.ca/Phasetwo` or `/candidate/dashboard` with a `Set-Cookie: ci_session=...` header.
  * **Failure:** HTTP `303 See Other` redirect to `https://www.phasetwo.ca/Phasetwo/login` or HTTP 200 re-rendering error banner.
* **Role Verification:** Successful redirect confirms `candidate` role.

### 2.2 Employer / Recruiter Login
* **URL:** `https://www.phasetwo.ca/Login/recruiter_login`
* **HTTP Method:** `POST`
* **Content-Type:** `application/x-www-form-urlencoded`
* **Form Fields:**
  * `company_email` (string, required): Recruiter or corporate email address.
  * `password` (string, required): Account password.
* **Server Response Contract:**
  * **Success:** HTTP `303 See Other` redirect to `https://www.phasetwo.ca/company/dashboard` with a `Set-Cookie: ci_session=...` header.
  * **Failure:** HTTP `303 See Other` redirect to `https://www.phasetwo.ca/Phasetwo/recruiter_login`.
* **Role Verification:** Successful redirect confirms `employer` role.

### 2.3 Candidate Registration
* **URL:** `https://www.phasetwo.ca/Register/register`
* **HTTP Method:** `POST`
* **Content-Type:** `application/x-www-form-urlencoded`
* **Form Fields:**
  * `first_name` (string, required): Candidate first name.
  * `last_name` (string, required): Candidate last name.
  * `email` (string, required): Valid email address.
  * `phone` (string, required): Canadian/international phone number.
  * `stream` (string, required): Professional domain (e.g., `Information Technology`, `Banking & Finance`, `Healthcare`).
  * `dob` (string, required): Date of birth in `YYYY-MM-DD` format.
  * `jobpreference` (string, required): Location or remote preference (e.g., `Toronto, ON / Remote`).
  * `qualification` (string, required): Educational credential (e.g., `Post Graduation`, `Graduation`, `Doctorate`).
  * `exp_year` (string, required): Years of professional experience (e.g., `10+ year`).
  * `password` (string, required): Account password (minimum 6 characters).
  * `cnf_password` (string, required): Password confirmation (must strictly match `password`).
* **Server Response Contract:**
  * **Success:** HTTP `303 See Other` redirect to login or confirmation view.

### 2.4 Employer / Recruiter Registration
* **URL:** `https://www.phasetwo.ca/Register/register_employeer`
* **HTTP Method:** `POST`
* **Content-Type:** `application/x-www-form-urlencoded`
* **Form Fields:**
  * `name` (string, required): Contact person's full name.
  * `company_name` (string, required): Registered business / organization name.
  * `company_phone` (string, required): Corporate telephone number.
  * `company_email` (string, required): Official company email address.
  * `stream` (string, required): Industry sector / primary domain.
  * `company_website` (string, optional): Organization website URL.
  * `plan_code` (string, required): PhaseTwo Starter Tier identifier (`PLANEMP00362f199753`).
  * `password` (string, required): Account password.
  * `cnf_password` (string, required): Password confirmation.
* **Server Response Contract:**
  * **Success:** HTTP `303 See Other` redirect confirming registration.

### 2.5 Forgot Password / Password Reset Link
* **URL:** `https://www.phasetwo.ca/Forgot_password/send_reset_link`
* **HTTP Method:** `POST`
* **Content-Type:** `application/x-www-form-urlencoded`
* **Form Fields:**
  * `email` (string, required): Registered email address.
* **Server Response Contract:**
  * **Success:** HTTP `303 See Other` or HTTP 200 confirming reset email dispatch.

### 2.6 Logout
* **URL:** `https://www.phasetwo.ca/logout`
* **HTTP Method:** `GET`
* **Server Action:** Destroys CodeIgniter session, unsets server session variables, expires `ci_session` cookie, and redirects to home.

---

## 3. Session & Security Mechanics

| Requirement | Production Implementation | Native Mobile Handling |
| :--- | :--- | :--- |
| **Session Cookie** | `ci_session` (Length: ~300 chars, hex/base64 encoded) | Parsed and managed by `AuthApiService` via `dart:io` `CookieJar`. |
| **Cookie Flags** | `HttpOnly; Secure; SameSite=Lax; Max-Age=7200` | Securely stored in encrypted SharedPreferences via `AuthSessionService`. |
| **CSRF Token** | Not enforced on current HTML form endpoints | Native forms post directly with standard headers. Future CSRF endpoints can be accommodated without UI rework. |
| **CAPTCHA / 2FA** | No CAPTCHA challenge on standard login/register | UI contains fallback architecture to intercept challenges if backend enables them. |
| **WebView Synchronization** | Browser sessions require `ci_session` cookie | Synchronized to `WebViewCookieManager` on domain `.phasetwo.ca` upon successful login. |

---

## 4. Role Segregation and Safety

1. **Role Enforcement:**
   * Candidate credentials cannot authenticate against `/Login/recruiter_login`.
   * Employer credentials cannot authenticate against `/Login`.
   * `AuthSessionService.instance.userRole` strictly isolates candidate and employer session state.
2. **Credential Privacy:**
   * Passwords and raw credential tokens are never logged, cached, or persisted in plain text.
   * Only the session token (`ci_session`) and verified email/role are stored in persistent state.
3. **Graceful Error Handling:**
   * Timeout, DNS resolution failures, and server 5xx errors display user-friendly Canadian English error banners without crashing or exposing stack traces.
