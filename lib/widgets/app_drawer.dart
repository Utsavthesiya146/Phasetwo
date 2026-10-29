import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../screens/auth/candidate_login_screen.dart';
import '../screens/auth/candidate_signup_screen.dart';
import '../screens/auth/employer_login_screen.dart';
import '../screens/auth/employer_signup_screen.dart';

/// Professional Navigation Drawer for PhaseTwo.
class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.onNavigateToTab,
    required this.onOpenUrl,
    this.isAuthenticated = false,
    this.userRole,
    this.onLogout,
    this.onOpenWelcome,
    this.onAuthSuccess,
  });

  final void Function(int tabIndex) onNavigateToTab;
  final void Function(String url) onOpenUrl;
  final bool isAuthenticated;
  final String? userRole;
  final VoidCallback? onLogout;
  final VoidCallback? onOpenWelcome;
  final VoidCallback? onAuthSuccess;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          children: <Widget>[
            // Drawer Header with PhaseTwo Branding
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 54,
                bottom: 24,
                left: 20,
                right: 20,
              ),
              decoration: const BoxDecoration(
                gradient: AppConfig.heroNavyGradient,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Logo container
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 30,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Text(
                        AppConfig.appName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppConfig.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Flexible Work for Experienced Professionals',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '🇨🇦 Canada Wide',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppConfig.accentGreen.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppConfig.accentGreen.withOpacity(0.6),
                            width: 0.8,
                          ),
                        ),
                        child: const Text(
                          '10+ Yrs Talent',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Scrollable Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: <Widget>[
                  _buildSectionHeader('DISCOVER & SEARCH'),
                  _buildDrawerTile(
                    icon: Icons.home_rounded,
                    title: 'Home Dashboard',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigateToTab(0);
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.work_outline_rounded,
                    title: 'Search Jobs & Gigs',
                    badge: 'Explore',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigateToTab(1);
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.flash_on_rounded,
                    title: 'Browse Live Gigs',
                    onTap: () {
                      Navigator.pop(context);
                      onOpenUrl(AppConfig.gigsUrl);
                    },
                  ),

                  const Divider(height: 24, thickness: 0.8, indent: 16, endIndent: 16),
                  _buildSectionHeader('CANDIDATE PORTAL'),
                  _buildDrawerTile(
                    icon: Icons.person_outline_rounded,
                    title: 'Candidate Hub',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigateToTab(2);
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.login_rounded,
                    title: 'Candidate Sign In',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CandidateLoginScreen(
                            onAuthSuccess: onAuthSuccess,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.person_add_alt_1_outlined,
                    title: 'Register as Candidate',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CandidateSignupScreen(
                            onAuthSuccess: onAuthSuccess,
                          ),
                        ),
                      );
                    },
                  ),

                  _buildDrawerTile(
                    icon: Icons.dashboard_outlined,
                    title: 'Candidate Dashboard',
                    onTap: () {
                      Navigator.pop(context);
                      onOpenUrl(AppConfig.candidateDashboardUrl);
                    },
                  ),

                  const Divider(height: 24, thickness: 0.8, indent: 16, endIndent: 16),
                  _buildSectionHeader('EMPLOYER & RECRUITER'),
                  _buildDrawerTile(
                    icon: Icons.business_center_outlined,
                    title: 'Employer Hub',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigateToTab(3);
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.add_circle_outline_rounded,
                    title: 'Post a Job or Gig',
                    badge: 'Hire',
                    badgeColor: AppConfig.accentGreen,
                    onTap: () {
                      Navigator.pop(context);
                      onOpenUrl(AppConfig.postJobUrl);
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.admin_panel_settings_outlined,
                    title: 'Employer Sign In',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmployerLoginScreen(
                            onAuthSuccess: onAuthSuccess,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.group_add_outlined,
                    title: 'Register Employer',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmployerSignupScreen(
                            onAuthSuccess: onAuthSuccess,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.dashboard_customize_outlined,
                    title: 'Employer Dashboard',
                    onTap: () {
                      Navigator.pop(context);
                      onOpenUrl(AppConfig.employerDashboardUrl);
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.card_membership_rounded,
                    title: 'Pricing & Plans',
                    onTap: () {
                      Navigator.pop(context);
                      onOpenUrl(AppConfig.pricingUrl);
                    },
                  ),

                  const Divider(height: 24, thickness: 0.8, indent: 16, endIndent: 16),
                  _buildSectionHeader('ABOUT & POLICIES'),
                  _buildDrawerTile(
                    icon: Icons.info_outline_rounded,
                    title: 'About PhaseTwo',
                    onTap: () {
                      Navigator.pop(context);
                      onOpenUrl(AppConfig.aboutUrl);
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.help_outline_rounded,
                    title: 'Need Assistance?',
                    onTap: () {
                      Navigator.pop(context);
                      onOpenUrl(AppConfig.assistanceUrl);
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.quiz_outlined,
                    title: 'Frequently Asked Questions',
                    onTap: () {
                      Navigator.pop(context);
                      onOpenUrl(AppConfig.faqUrl);
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.mail_outline_rounded,
                    title: 'Contact Us',
                    onTap: () {
                      Navigator.pop(context);
                      onOpenUrl(AppConfig.contactUrl);
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.policy_outlined,
                    title: 'Privacy Policy',
                    onTap: () {
                      Navigator.pop(context);
                      onOpenUrl(AppConfig.privacyUrl);
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.gavel_outlined,
                    title: 'Terms & Conditions',
                    onTap: () {
                      Navigator.pop(context);
                      onOpenUrl(AppConfig.termsUrl);
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.delete_outline_rounded,
                    title: 'Account & Data Deletion',
                    badge: 'Compliance',
                    badgeColor: AppConfig.errorRed,
                    onTap: () {
                      Navigator.pop(context);
                      _showAccountDeletionDialog(context);
                    },
                  ),
                  const Divider(height: 16, color: AppConfig.cardBorder),
                  if (isAuthenticated)
                    _buildDrawerTile(
                      icon: Icons.logout_rounded,
                      title: 'Sign Out / Logout',
                      badge: userRole != null
                          ? '${userRole![0].toUpperCase()}${userRole!.substring(1)}'
                          : 'Active',
                      badgeColor: AppConfig.accentGreenDark,
                      onTap: () {
                        Navigator.pop(context);
                        onLogout?.call();
                      },
                    )
                  else
                    _buildDrawerTile(
                      icon: Icons.login_rounded,
                      title: 'Sign In / Register',
                      badge: 'Account',
                      badgeColor: AppConfig.primaryColor,
                      onTap: () {
                        Navigator.pop(context);
                        onOpenWelcome?.call();
                      },
                    ),
                ],
              ),
            ),

            // Footer (Clean unified app branding - NO Web Portal button)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: AppConfig.backgroundLight,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.verified_user_outlined,
                    size: 18,
                    color: AppConfig.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'PhaseTwo Canada',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppConfig.textDark,
                          ),
                        ),
                        Text(
                          'Unified Mobile Application',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppConfig.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppConfig.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '🍁 Live App',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppConfig.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppConfig.textMuted,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildDrawerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? badge,
    Color badgeColor = AppConfig.primaryColor,
  }) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -1),
      horizontalTitleGap: 12,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Icon(icon, color: AppConfig.primaryNavy, size: 21),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w500,
          color: AppConfig.textDark,
        ),
      ),
      trailing: badge != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: badgeColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: badgeColor.withOpacity(0.4), width: 0.7),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  color: badgeColor,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: Colors.grey,
            ),
      onTap: onTap,
    );
  }

  void _showAccountDeletionDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConfig.errorRed.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_forever_rounded,
                  color: AppConfig.errorRed,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Account Deletion',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConfig.textDark,
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Under PhaseTwo data privacy governance and app store requirements, you have the right to request deletion of your account and personal data.',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: AppConfig.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppConfig.backgroundLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppConfig.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'What will be deleted:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppConfig.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        '• Candidate profile, resume & application history\n'
                        '• Employer profile & active/archived job postings\n'
                        '• Account credentials and authentication records',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppConfig.textMuted,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Contact Support: ${AppConfig.supportEmail}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppConfig.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Account deletion requests are processed within 30 days of verification.',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontStyle: FontStyle.italic,
                    color: AppConfig.textMuted,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppConfig.textMuted),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onOpenUrl(AppConfig.privacyUrl);
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppConfig.primaryDark),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Privacy Policy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onOpenUrl(AppConfig.accountDeletionUrl);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConfig.errorRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Request Deletion'),
            ),
          ],
        );
      },
    );
  }
}

