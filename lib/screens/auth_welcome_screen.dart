import 'package:flutter/material.dart';
import '../config/app_config.dart';
import 'auth/candidate_login_screen.dart';
import 'auth/candidate_signup_screen.dart';
import 'auth/employer_login_screen.dart';
import 'auth/employer_signup_screen.dart';

/// PhaseTwo Native Authentication Welcome Screen.
/// Displayed on app startup for unauthenticated users.
/// Features PhaseTwo branding, approved Option B blue gradient, welcome headline,
/// and direct access to native candidate and employer authentication screens.
class AuthWelcomeScreen extends StatelessWidget {
  const AuthWelcomeScreen({
    super.key,
    this.onOpenAuthUrl,
    required this.onExploreAsGuest,
    this.onCandidateLogin,
    this.onEmployerLogin,
    this.onCandidateSignup,
    this.onEmployerSignup,
    this.onAuthSuccess,
  });

  final void Function(String url)? onOpenAuthUrl;
  final VoidCallback onExploreAsGuest;
  final VoidCallback? onCandidateLogin;
  final VoidCallback? onEmployerLogin;
  final VoidCallback? onCandidateSignup;
  final VoidCallback? onEmployerSignup;
  final VoidCallback? onAuthSuccess;

  @override
  Widget build(BuildContext context) {
    final double textScale =
        MediaQuery.textScalerOf(context).scale(1.0).clamp(0.85, 1.25);

    return Scaffold(
      backgroundColor: AppConfig.backgroundLight,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Hero Banner with Option B Modern Dynamic Blue Gradient
            Container(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
              decoration: const BoxDecoration(
                gradient: AppConfig.heroNavyGradient,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Color(0x330F2B46),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Logo container
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 28,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Text(
                            AppConfig.appName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppConfig.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                            width: 0.8,
                          ),
                        ),
                        child: const Text(
                          '🍁 Canada Wide',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Canadian Network Frosted Glass Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.28),
                        width: 0.8,
                      ),
                    ),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '🍁 Canada\'s Executive & Senior Talent Network',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Professional Welcome Headline
                  Text(
                    'Experience Is Your Greatest Asset',
                    style: TextStyle(
                      fontSize: 22 * textScale,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.2,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Connecting experienced leaders, fractional executives, and mature professionals with premier Canadian employers.',
                    style: TextStyle(
                      fontSize: 13 * textScale,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Authentication Cards Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  // 1. Candidate Portal Card
                  _buildAuthCard(
                    context: context,
                    icon: Icons.person_rounded,
                    iconBg: AppConfig.primaryLight,
                    iconColor: AppConfig.primaryNavy,
                    sectionTitle: 'Candidate Portal',
                    subtitle: 'For experienced professionals seeking executive, fractional, and flexible roles.',
                    loginLabel: 'Candidate Login',
                    signupLabel: 'Candidate Sign Up',
                    onLogin: () {
                      onOpenAuthUrl?.call(AppConfig.candidateLoginUrl);
                      if (onCandidateLogin != null) {
                        onCandidateLogin!();
                      } else if (onOpenAuthUrl == null) {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => CandidateLoginScreen(
                              onLoginSuccess: onAuthSuccess,
                              onAuthSuccess: onAuthSuccess,
                            ),
                          ),
                        );
                      }
                    },
                    onSignup: () {
                      onOpenAuthUrl?.call(AppConfig.candidateRegisterUrl);
                      if (onCandidateSignup != null) {
                        onCandidateSignup!();
                      } else if (onOpenAuthUrl == null) {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => CandidateSignupScreen(
                              onSignupSuccess: onAuthSuccess,
                              onAuthSuccess: onAuthSuccess,
                            ),
                          ),
                        );
                      }
                    },
                    primaryColor: AppConfig.primaryNavy,
                  ),

                  const SizedBox(height: 16),

                  // 2. Employer Portal Card
                  _buildAuthCard(
                    context: context,
                    icon: Icons.business_center_rounded,
                    iconBg: AppConfig.accentGreenLight,
                    iconColor: AppConfig.accentGreenDark,
                    sectionTitle: 'Employer & Recruiter Portal',
                    subtitle: 'For Canadian organizations seeking verified, seasoned executive talent.',
                    loginLabel: 'Employer Login',
                    signupLabel: 'Employer Registration',
                    onLogin: () {
                      onOpenAuthUrl?.call(AppConfig.employerLoginUrl);
                      if (onEmployerLogin != null) {
                        onEmployerLogin!();
                      } else if (onOpenAuthUrl == null) {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => EmployerLoginScreen(
                              onLoginSuccess: onAuthSuccess,
                              onAuthSuccess: onAuthSuccess,
                            ),
                          ),
                        );
                      }
                    },
                    onSignup: () {
                      onOpenAuthUrl?.call(AppConfig.registerEmployerUrl);
                      if (onEmployerSignup != null) {
                        onEmployerSignup!();
                      } else if (onOpenAuthUrl == null) {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => EmployerSignupScreen(
                              onSignupSuccess: onAuthSuccess,
                              onAuthSuccess: onAuthSuccess,
                            ),
                          ),
                        );
                      }
                    },
                    primaryColor: AppConfig.primaryNavy,
                  ),

                  const SizedBox(height: 20),

                  // Guest Exploration Link
                  Center(
                    child: TextButton.icon(
                      onPressed: onExploreAsGuest,
                      style: TextButton.styleFrom(
                        foregroundColor: AppConfig.textMuted,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      icon: const Text(
                        'Explore Platform as Guest',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppConfig.primaryNavy,
                        ),
                      ),
                      label: const Icon(Icons.arrow_forward_rounded, size: 16, color: AppConfig.primaryNavy),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthCard({
    required BuildContext context,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String sectionTitle,
    required String subtitle,
    required String loginLabel,
    required String signupLabel,
    required VoidCallback onLogin,
    required VoidCallback onSignup,
    required Color primaryColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppConfig.cardBorder.withOpacity(0.8)),
        boxShadow: AppConfig.modernCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  sectionTitle,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    color: AppConfig.primaryNavy,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppConfig.textMuted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final Widget loginBtn = ElevatedButton(
                onPressed: onLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    loginLabel,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              );

              final Widget signupBtn = OutlinedButton(
                onPressed: onSignup,
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  side: const BorderSide(color: AppConfig.cardBorder, width: 1.2),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    signupLabel,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );

              // Responsive breakpoint: stack on ultra-narrow screens (< 320px inner width)
              if (constraints.maxWidth < 270) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    loginBtn,
                    const SizedBox(height: 8),
                    signupBtn,
                  ],
                );
              }

              return Row(
                children: <Widget>[
                  Expanded(child: loginBtn),
                  const SizedBox(width: 10),
                  Expanded(child: signupBtn),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
