import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Authentication state classifications for PhaseTwo.
enum AuthStatus {
  unauthenticated,
  candidateAuthenticated,
  employerAuthenticated,
  sessionExpired,
}

/// PhaseTwo Authentication Session Service.
/// Manages verification of authentic website sessions without storing passwords,
/// creating mock users, or relying on ephemeral guest cookies like PHPSESSID.
class AuthSessionService {
  static const String _keyIsAuthenticated = 'phasetwo_auth_verified';
  static const String _keyUserRole = 'phasetwo_user_role'; // 'candidate' | 'employer'
  static const String _keyLastAuthTimestamp = 'phasetwo_last_auth_time';
  static const String _keySessionToken = 'phasetwo_session_token';
  static const String _keyUserEmail = 'phasetwo_user_email';

  /// Session validity window matching PhaseTwo's CodeIgniter ci_session lifetime (2 hours)
  static const Duration sessionTimeout = Duration(hours: 2);

  /// Singleton instance
  static final AuthSessionService instance = AuthSessionService._internal();
  AuthSessionService._internal();

  final ValueNotifier<AuthStatus> statusNotifier =
      ValueNotifier<AuthStatus>(AuthStatus.unauthenticated);
  final ValueNotifier<bool> isAuthenticatedNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<String?> userRoleNotifier = ValueNotifier<String?>(null);
  final ValueNotifier<String?> userEmailNotifier = ValueNotifier<String?>(null);
  final ValueNotifier<String?> sessionTokenNotifier = ValueNotifier<String?>(null);

  /// Initializes and checks stored authentication state on startup
  Future<bool> init() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool isAuth = prefs.getBool(_keyIsAuthenticated) ?? false;
      final String? role = prefs.getString(_keyUserRole);
      final String? email = prefs.getString(_keyUserEmail);
      final String? token = prefs.getString(_keySessionToken);
      final int lastAuthTime = prefs.getInt(_keyLastAuthTimestamp) ?? 0;

      if (!isAuth || lastAuthTime == 0) {
        _setStatus(AuthStatus.unauthenticated, null, null, null);
        return false;
      }

      // Check session expiry against server lifetime window
      final int now = DateTime.now().millisecondsSinceEpoch;
      if (now - lastAuthTime > sessionTimeout.inMilliseconds) {
        debugPrint('[AuthSessionService] Session expired (timeout elapsed).');
        await clearSession(isExpired: true);
        return false;
      }

      // Valid unexpired session restored
      final AuthStatus status = role == 'employer'
          ? AuthStatus.employerAuthenticated
          : AuthStatus.candidateAuthenticated;
      _setStatus(status, role, email, token);

      if (token != null && token.isNotEmpty) {
        await syncCookiesToWebView(token);
      }

      return true;
    } catch (e) {
      debugPrint('[AuthSessionService] Init error: $e');
      _setStatus(AuthStatus.unauthenticated, null, null, null);
      return false;
    }
  }

  /// Checks if a valid session is currently verified
  bool get isAuthenticated =>
      statusNotifier.value == AuthStatus.candidateAuthenticated ||
      statusNotifier.value == AuthStatus.employerAuthenticated;

  AuthStatus get status => statusNotifier.value;
  String? get userRole => userRoleNotifier.value;
  String? get userEmail => userEmailNotifier.value;
  String? get sessionToken => sessionTokenNotifier.value;
  bool get isCandidate => status == AuthStatus.candidateAuthenticated;
  bool get isEmployer => status == AuthStatus.employerAuthenticated;
  bool get isExpired => status == AuthStatus.sessionExpired;

  void _setStatus(AuthStatus status, String? role, String? email, String? token) {
    statusNotifier.value = status;
    isAuthenticatedNotifier.value =
        status == AuthStatus.candidateAuthenticated ||
        status == AuthStatus.employerAuthenticated;
    userRoleNotifier.value = role;
    userEmailNotifier.value = email;
    sessionTokenNotifier.value = token;
  }

  /// Evaluates DOM signals returned from the in-app WebView
  Future<bool> evaluateWebsiteSignal(String jsonSignal, String currentUrl) async {
    try {
      // Decode JSON string returned from JavaScript
      dynamic data;
      try {
        data = jsonDecode(jsonSignal);
      } catch (_) {
        // Strip escaped quotes if wrapped by platform
        final String unescaped = jsonSignal
            .replaceAll(r'\"', '"')
            .replaceAll(RegExp(r'^"|"$'), '');
        data = jsonDecode(unescaped);
      }

      if (data is Map) {
        final bool hasLogout = data['hasLogout'] == true;
        final bool isEmployerSignal = data['isEmployer'] == true ||
            currentUrl.toLowerCase().contains('recruiter') ||
            currentUrl.toLowerCase().contains('company');

        if (hasLogout) {
          final String role = isEmployerSignal ? 'employer' : 'candidate';
          await setVerifiedSession(authenticated: true, role: role);
          return true;
        }
      }
    } catch (e) {
      debugPrint('[AuthSessionService] evaluateWebsiteSignal error: $e');
    }
    return false;
  }

  /// Inspects live WebView URLs to detect reliable website session signals
  Future<bool> evaluateWebsiteUrl(String url) async {
    final String lower = url.toLowerCase();

    // 1. Detect Server-Side Logout Signal
    if (lower.contains('/logout') ||
        lower.contains('/login/logout') ||
        lower.contains('logged_out=1') ||
        lower.contains('action=logout')) {
      await clearSession();
      return false;
    }

    // 2. Detect Reliable Employer Authentication Signal
    // CodeIgniter company routes only accessible after successful employer login
    if (lower.contains('/company/new_job_post') ||
        lower.contains('/company/dashboard') ||
        lower.contains('/company/manage_jobs') ||
        lower.contains('/employer/dashboard') ||
        lower.contains('/employer/profile')) {
      await setVerifiedSession(
        authenticated: true,
        role: 'employer',
      );
      return true;
    }

    // 3. Detect Reliable Candidate Authentication Signal
    if (lower.contains('/candidate/dashboard') ||
        lower.contains('/candidate/profile') ||
        lower.contains('/candidate/applied_jobs') ||
        lower.contains('/candidate_applied_jobs')) {
      await setVerifiedSession(
        authenticated: true,
        role: 'candidate',
      );
      return true;
    }

    return false;
  }

  /// Touches the session to refresh the active timestamp during ongoing app use
  Future<void> touchSession() async {
    if (!isAuthenticated) return;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keyLastAuthTimestamp, DateTime.now().millisecondsSinceEpoch);
    } catch (_) {}
  }

  /// Persists confirmed authentication status
  Future<void> setVerifiedSession({
    required bool authenticated,
    String? role,
    String? email,
    String? sessionToken,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsAuthenticated, authenticated);
      if (role != null) {
        await prefs.setString(_keyUserRole, role);
      } else {
        await prefs.remove(_keyUserRole);
      }
      if (email != null) {
        await prefs.setString(_keyUserEmail, email);
      } else {
        await prefs.remove(_keyUserEmail);
      }
      if (sessionToken != null) {
        await prefs.setString(_keySessionToken, sessionToken);
      } else {
        await prefs.remove(_keySessionToken);
      }
      await prefs.setInt(_keyLastAuthTimestamp, DateTime.now().millisecondsSinceEpoch);

      final AuthStatus status = authenticated
          ? (role == 'employer'
              ? AuthStatus.employerAuthenticated
              : AuthStatus.candidateAuthenticated)
          : AuthStatus.unauthenticated;
      _setStatus(status, role, email, sessionToken);

      if (sessionToken != null && sessionToken.isNotEmpty) {
        await syncCookiesToWebView(sessionToken);
      }
    } catch (e) {
      debugPrint('[AuthSessionService] setVerifiedSession error: $e');
    }
  }

  /// Synchronizes authentic server session cookies to in-app WebView
  Future<void> syncCookiesToWebView(String sessionToken) async {
    try {
      final WebViewCookieManager cookieManager = WebViewCookieManager();
      await cookieManager.setCookie(
        WebViewCookie(
          name: 'ci_session',
          value: sessionToken,
          domain: 'www.phasetwo.ca',
          path: '/',
        ),
      );
      await cookieManager.setCookie(
        WebViewCookie(
          name: 'ci_session',
          value: sessionToken,
          domain: 'phasetwo.ca',
          path: '/',
        ),
      );
    } catch (e) {
      debugPrint('[AuthSessionService] syncCookiesToWebView error: $e');
    }
  }

  /// Clears verified session upon logout or expiration
  Future<void> clearSession({bool isExpired = false}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyIsAuthenticated);
      await prefs.remove(_keyUserRole);
      await prefs.remove(_keyUserEmail);
      await prefs.remove(_keySessionToken);
      await prefs.remove(_keyLastAuthTimestamp);

      try {
        final WebViewCookieManager cookieManager = WebViewCookieManager();
        await cookieManager.clearCookies();
      } catch (_) {}

      _setStatus(
        isExpired ? AuthStatus.sessionExpired : AuthStatus.unauthenticated,
        null,
        null,
        null,
      );
    } catch (e) {
      debugPrint('[AuthSessionService] clearSession error: $e');
    }
  }
}
