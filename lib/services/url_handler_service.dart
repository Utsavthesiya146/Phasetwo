import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/app_config.dart';

/// URL Handling service to classify and process internal, external,
/// mailto, tel, payment, and file download URLs.
class UrlHandlerService {
  UrlHandlerService._();

  /// Checks whether a given URI belongs to PhaseTwo or an allowed payment/auth gateway.
  static bool isInternalUrl(Uri uri) {
    final String host = uri.host.toLowerCase();
    if (host.isEmpty) return false;

    // Check primary domain
    if (host == AppConfig.primaryDomain ||
        host == AppConfig.wwwPrimaryDomain ||
        host.endsWith('.${AppConfig.primaryDomain}')) {
      return true;
    }

    // Check payment & auth allowed hosts
    for (final String allowedHost in AppConfig.allowedExternalHosts) {
      if (host == allowedHost || host.endsWith('.$allowedHost')) {
        return true;
      }
    }

    return false;
  }

  /// Determines if a URL points to a downloadable file.
  static bool isDownloadUrl(Uri uri) {
    final String path = uri.path.toLowerCase();
    for (final String ext in AppConfig.downloadableExtensions) {
      if (path.endsWith(ext)) {
        return true;
      }
    }

    // Check query params or download flags
    if (uri.queryParameters.containsKey('download') ||
        uri.queryParameters['action'] == 'download' ||
        uri.queryParameters.containsKey('attachment')) {
      return true;
    }

    return false;
  }

  /// Checks if URL uses special external schemes like mailto, tel, sms, whatsapp.
  static bool isSpecialScheme(Uri uri) {
    final String scheme = uri.scheme.toLowerCase();
    return scheme == 'mailto' ||
        scheme == 'tel' ||
        scheme == 'sms' ||
        scheme == 'whatsapp' ||
        scheme == 'market';
  }

  /// Checks if the host is a known external social link that should open externally.
  static bool isSocialOrExternalLink(Uri uri) {
    final String host = uri.host.toLowerCase();
    for (final String extHost in AppConfig.externalSocialDomains) {
      if (host == extHost || host.endsWith('.$extHost')) {
        return true;
      }
    }
    return false;
  }

  /// Checks whether a URI corresponds to the PhaseTwo homepage.
  static bool isHomePageUrl(Uri uri) {
    final String host = uri.host.toLowerCase();
    if (host != AppConfig.primaryDomain && host != AppConfig.wwwPrimaryDomain) {
      return false;
    }
    final String path = uri.path.toLowerCase().trim();
    return path.isEmpty ||
        path == '/' ||
        path == '/phasetwo' ||
        path == '/phasetwo/' ||
        path == '/index.php' ||
        path == '/home';
  }

  /// Checks whether a URI corresponds to candidate login.
  static bool isCandidateLoginUrl(Uri uri) {
    final String path = uri.path.toLowerCase().trim();
    return path == '/login' ||
        path == '/phasetwo/login' ||
        path.endsWith('/candidate_login');
  }

  /// Checks whether a URI corresponds to employer/recruiter login.
  static bool isEmployerLoginUrl(Uri uri) {
    final String path = uri.path.toLowerCase().trim();
    return path == '/recruiter_login' ||
        path == '/login/recruiter_login' ||
        path == '/phasetwo/recruiter_login' ||
        path.contains('recruiter_login');
  }

  /// Checks whether a URI corresponds to candidate signup/registration.
  static bool isCandidateRegisterUrl(Uri uri) {
    final String path = uri.path.toLowerCase().trim();
    return path == '/register' ||
        path == '/register/register' ||
        path == '/phasetwo/register';
  }

  /// Checks whether a URI corresponds to employer/recruiter registration.
  static bool isEmployerRegisterUrl(Uri uri) {
    final String path = uri.path.toLowerCase().trim();
    return path == '/recruiter_register' ||
        path == '/register/register_employeer' ||
        path == '/register_employer';
  }

  /// Checks whether a URI corresponds to password reset/forgot password.
  static bool isForgotPasswordUrl(Uri uri) {
    final String path = uri.path.toLowerCase().trim();
    return path.contains('forgot_password') || path.contains('reset_password');
  }

  /// Checks whether a URI is any authentication-related flow.
  static bool isAuthUrl(Uri uri) {
    return isCandidateLoginUrl(uri) ||
        isEmployerLoginUrl(uri) ||
        isCandidateRegisterUrl(uri) ||
        isEmployerRegisterUrl(uri) ||
        isForgotPasswordUrl(uri);
  }

  /// Checks whether a URI corresponds to a logout action.
  static bool isLogoutUrl(Uri uri) {
    final String path = uri.path.toLowerCase().trim();
    return path == '/logout' ||
        path == '/recruiter_logout' ||
        path == '/phasetwo/logout';
  }

  /// Launches an external URL in the system browser or native app.
  static Future<bool> launchExternal(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        // Fallback with platformDefault
        return await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
      }
    } catch (e) {
      debugPrint('[UrlHandlerService] Failed to launch external URL: $url - $e');
      return false;
    }
  }
}
