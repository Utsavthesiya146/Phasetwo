import 'package:flutter/material.dart';

/// PhaseTwo Application Configuration & Branding Constants
class AppConfig {
  AppConfig._();

  static const String appName = 'PhaseTwo';
  static const String initialUrl = 'https://www.phasetwo.ca/';
  static const String candidateLoginUrl = 'https://www.phasetwo.ca/login';
  static const String employerLoginUrl = 'https://www.phasetwo.ca/recruiter_login';
  static const String recruiterLoginUrl = employerLoginUrl;
  static const String registerCandidateUrl = 'https://www.phasetwo.ca/register';
  static const String candidateRegisterUrl = registerCandidateUrl;
  static const String registerEmployerUrl = 'https://www.phasetwo.ca/recruiter_register';
  static const String recruiterRegisterUrl = registerEmployerUrl;
  static const String candidateLogoutUrl = 'https://www.phasetwo.ca/logout';
  static const String employerLogoutUrl = 'https://www.phasetwo.ca/recruiter_logout';

  // Primary Domain
  static const String primaryDomain = 'phasetwo.ca';
  static const String wwwPrimaryDomain = 'www.phasetwo.ca';

  // Branding Palette
  static const Color primaryColor = Color(0xFF38B6FF);
  static const Color primaryDark = Color(0xFF0284C7);
  static const Color primaryNavy = Color(0xFF0F2B46);
  static const Color primaryLight = Color(0xFFE0F2FE);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentGreenLight = Color(0xFFDCFCE7);
  static const Color accentGreenDark = Color(0xFF15803D);
  static const Color backgroundLight = Color(0xFFF1F5F9);
  static const Color surfaceWhite = Colors.white;
  static const Color textDark = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF64748B);
  static const Color cardBorder = Color(0xFFE2E8F0);
  static const Color errorRed = Color(0xFFEF4444);

  // Option B Modern Dynamic Design Tokens
  static const LinearGradient heroNavyGradient = LinearGradient(
    colors: <Color>[primaryNavy, Color(0xFF0C4A6E), primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroCandidateGradient = LinearGradient(
    colors: <Color>[primaryDark, primaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroEmployerGradient = LinearGradient(
    colors: <Color>[primaryNavy, Color(0xFF1E293B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static List<BoxShadow> get modernCardShadow => <BoxShadow>[
        BoxShadow(
          color: primaryNavy.withOpacity(0.07),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get buttonShadow => <BoxShadow>[
        BoxShadow(
          color: primaryColor.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ];

  // PhaseTwo URLs
  static const String jobsUrl = 'https://www.phasetwo.ca/jobs';
  static const String gigsUrl = 'https://www.phasetwo.ca/gigs';
  static const String postJobUrl = 'https://www.phasetwo.ca/company/New_job_post';
  static const String pricingUrl = 'https://www.phasetwo.ca/pricing';
  static const String aboutUrl = 'https://www.phasetwo.ca/about';
  static const String faqUrl = 'https://www.phasetwo.ca/faq';
  static const String contactUrl = 'https://www.phasetwo.ca/contact';
  static const String blogsUrl = 'https://www.phasetwo.ca/Blogs';
  static const String assistanceUrl = 'https://www.phasetwo.ca/Assistance';
  static const String candidateDashboardUrl = 'https://www.phasetwo.ca/candidate/dashboard';
  static const String employerDashboardUrl = 'https://www.phasetwo.ca/employer/dashboard';
  static const String privacyUrl = 'https://www.phasetwo.ca/privacy_policy';
  static const String termsUrl = 'https://www.phasetwo.ca/terms_conditions';
  static const String forgotPasswordUrl = 'https://www.phasetwo.ca/Forgot_password';
  static const String browseJobsUrl = 'https://www.phasetwo.ca/browse_jobs';
  static const String categoriesUrl = 'https://www.phasetwo.ca/categorys';
  static const String locationsUrl = 'https://www.phasetwo.ca/Job_locations';

  // Downloadable file extensions
  static const List<String> downloadableExtensions = <String>[
    '.pdf',
    '.doc',
    '.docx',
    '.xls',
    '.xlsx',
    '.csv',
    '.ppt',
    '.pptx',
    '.zip',
    '.rar',
    '.7z',
    '.tar',
    '.gz',
    '.apk',
    '.mp4',
    '.mp3',
    '.jpg',
    '.jpeg',
    '.png',
  ];

  // Whitelisted payment and authentication domains that must be handled smoothly
  static const List<String> allowedExternalHosts = <String>[
    'checkout.stripe.com',
    'js.stripe.com',
    'hooks.stripe.com',
    'paypal.com',
    'www.paypal.com',
    'sandbox.paypal.com',
    'accounts.google.com',
    'appleid.apple.com',
    'moneris.com',
    'esqa.moneris.com',
  ];

  // External social media domains that should open in external browser
  static const List<String> externalSocialDomains = <String>[
    'facebook.com',
    'twitter.com',
    'x.com',
    'linkedin.com',
    'instagram.com',
    'youtube.com',
    'webhostingbaba.com',
  ];
}

