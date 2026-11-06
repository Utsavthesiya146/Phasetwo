import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/app_config.dart';
import 'auth/candidate_login_screen.dart';
import 'auth/candidate_signup_screen.dart';
import 'auth/employer_login_screen.dart';
import 'auth/employer_signup_screen.dart';

/// PhaseTwo Native Authentication Welcome Screen (LinkedIn, Indeed & Job Hai Theme).
/// Displays on startup for unauthenticated users, providing modern mobile-first
/// Canadian Senior Executive network branding, quick access to Candidate & Employer portals,
/// and instant guest exploration.
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
            // 1. Hero Banner with Modern Dynamic Blue Gradient (LinkedIn / Indeed Executive Theme)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 52, 20, 26),
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
                  // Top Row: Logo + Instant Explore Shortcut
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
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
                          height: 26,
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
                      InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          onExploreAsGuest();
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.35),
                              width: 0.8,
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Explore Jobs',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Canadian Network Frosted Glass Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4.5),
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
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Professional Welcome Headline
                  Text(
                    'Experience Is Your Greatest Asset',
                    style: TextStyle(
                      fontSize: 22 * textScale,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.18,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Connecting experienced leaders, fractional executives, and mature professionals with premier Canadian employers.',
                    style: TextStyle(
                      fontSize: 13 * textScale,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Canadian Trust Badges Row
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: <Widget>[
                      _buildHeaderTrustChip('🍁 100% Canadian'),
                      _buildHeaderTrustChip('⚡ Fractional & Advisory'),
                      _buildHeaderTrustChip('🔒 Verified Network'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 2. Authentication Cards Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  // Candidate Portal Card (Vibrant Ocean Blue Button Theme)
                  _buildAuthCard(
                    context: context,
                    icon: Icons.person_rounded,
                    iconBg: AppConfig.primaryLight,
                    iconColor: AppConfig.primaryDark,
                    sectionTitle: 'Candidate Portal',
                    subtitle: 'For experienced professionals seeking executive, fractional, and flexible roles.',
                    loginLabel: 'Candidate Login',
                    signupLabel: 'Candidate Sign Up',
                    onLogin: () {
                      HapticFeedback.lightImpact();
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
                      HapticFeedback.lightImpact();
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
                    primaryColor: AppConfig.primaryColor,
                    primaryTextColor: AppConfig.primaryNavy,
                    hasGlow: true,
                  ),

                  const SizedBox(height: 14),

                  // Employer & Recruiter Portal Card (Executive Navy Theme)
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
                      HapticFeedback.lightImpact();
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
                      HapticFeedback.lightImpact();
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
                    primaryTextColor: Colors.white,
                    hasGlow: false,
                  ),

                  const SizedBox(height: 16),

                  // 3. Guest Exploration Card (Indeed & Job Hai Style)
                  InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onExploreAsGuest();
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppConfig.cardBorder),
                        boxShadow: AppConfig.modernCardShadow,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(Icons.search_rounded, size: 18, color: AppConfig.primaryDark),
                          const SizedBox(width: 8),
                          const Flexible(
                            child: Text(
                              'Explore Platform as Guest',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppConfig.primaryNavy,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_rounded, size: 15, color: AppConfig.primaryDark),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 4. Trust Footer
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(Icons.shield_outlined, size: 14, color: AppConfig.textMuted),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            '100% Verified Canadian Opportunities · PhaseTwo.ca',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppConfig.textMuted.withOpacity(0.9),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderTrustChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.22),
          width: 0.8,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
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
    required Color primaryTextColor,
    required bool hasGlow,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppConfig.cardBorder),
        boxShadow: AppConfig.modernCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      sectionTitle,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: AppConfig.primaryNavy,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppConfig.textMuted,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final Widget loginBtn = Container(
                decoration: hasGlow
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: AppConfig.buttonShadow,
                      )
                    : BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: AppConfig.primaryNavy.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                child: ElevatedButton(
                  onPressed: onLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: primaryTextColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      loginLabel,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              );

              final Widget signupBtn = OutlinedButton(
                onPressed: onSignup,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppConfig.primaryNavy,
                  side: const BorderSide(color: AppConfig.cardBorder, width: 1.4),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    signupLabel,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );

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
