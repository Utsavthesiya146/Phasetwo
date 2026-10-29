import 'package:flutter/material.dart';
import '../config/app_config.dart';
import 'auth/candidate_login_screen.dart';
import 'auth/candidate_signup_screen.dart';

/// PhaseTwo Option B: Modern Dynamic Candidate Section Hub.
/// Connects experienced Canadian candidates, returners, and fractional leaders
/// directly to live authentication, registration, dashboard, and assistance flows.
class CandidateSectionScreen extends StatelessWidget {
  const CandidateSectionScreen({
    super.key,
    required this.onOpenUrl,
    this.onAuthSuccess,
  });

  final void Function(String url) onOpenUrl;
  final VoidCallback? onAuthSuccess;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundLight,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Candidate Header Banner (Option B Gradient)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              decoration: const BoxDecoration(
                gradient: AppConfig.heroCandidateGradient,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Color(0x330284C7),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.35),
                        width: 0.8,
                      ),
                    ),
                    child: const Text(
                      '🍁 For Experienced Professionals & Returners',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your Experience is Your Greatest Asset',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'PhaseTwo is Canada\'s premier network connecting mature professionals with high-impact, flexible, fractional, and full-time opportunities.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.92),
                      fontSize: 13.5,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),

            // Primary Candidate Action Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final Widget loginBtn = Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: AppConfig.primaryNavy.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        onOpenUrl(AppConfig.candidateLoginUrl);
                        if (onAuthSuccess != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CandidateLoginScreen(
                                onAuthSuccess: onAuthSuccess,
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConfig.primaryNavy,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.login_rounded, size: 18),
                      label: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Candidate Login',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                        ),
                      ),
                    ),
                  );

                  final Widget registerBtn = Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppConfig.buttonShadow,
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        onOpenUrl(AppConfig.registerCandidateUrl);
                        if (onAuthSuccess != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CandidateSignupScreen(
                                onAuthSuccess: onAuthSuccess,
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConfig.primaryColor,
                        foregroundColor: AppConfig.primaryNavy,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.person_add_rounded, size: 18),
                      label: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Join PhaseTwo',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                        ),
                      ),
                    ),
                  );

                  if (constraints.maxWidth < 300) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        loginBtn,
                        const SizedBox(height: 8),
                        registerBtn,
                      ],
                    );
                  }

                  return Row(
                    children: <Widget>[
                      Expanded(child: loginBtn),
                      const SizedBox(width: 10),
                      Expanded(child: registerBtn),
                    ],
                  );
                },
              ),
            ),

            // 4 Candidate Feature Cards (Ambient Elevation)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: <Widget>[
                  _buildActionCard(
                    icon: Icons.dashboard_customize_outlined,
                    iconColor: AppConfig.primaryDark,
                    iconBg: AppConfig.primaryLight,
                    title: 'Candidate Dashboard',
                    description: 'View active applications, saved roles, and profile settings in your secure portal.',
                    actionLabel: 'Open Dashboard',
                    onTap: () => onOpenUrl(AppConfig.candidateDashboardUrl),
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    icon: Icons.flash_on_rounded,
                    iconColor: const Color(0xFFD97706),
                    iconBg: const Color(0xFFFEF3C7),
                    title: 'Browse Flexible Gigs',
                    description: 'Explore high-value project-based, advisory, and fractional contracts across Canada.',
                    actionLabel: 'Explore Gigs',
                    onTap: () => onOpenUrl(AppConfig.gigsUrl),
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    icon: Icons.support_agent_rounded,
                    iconColor: AppConfig.accentGreenDark,
                    iconBg: AppConfig.accentGreenLight,
                    title: 'Career & Resume Assistance',
                    description: 'Get expert guidance tailored for Phase 2 career transitions and returning professionals.',
                    actionLabel: 'Request Guidance',
                    onTap: () => onOpenUrl(AppConfig.assistanceUrl),
                  ),
                ],
              ),
            ),

            // Why PhaseTwo for Candidates Pillars
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppConfig.cardBorder.withOpacity(0.8)),
                  boxShadow: AppConfig.modernCardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Why Join PhaseTwo?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppConfig.primaryNavy,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildPillarItem(
                      icon: Icons.check_circle_outline_rounded,
                      title: 'Zero Age Bias Environment',
                      desc: 'Your years of experience and proven leadership are actively sought by Canadian employers.',
                    ),
                    const Divider(height: 20, color: AppConfig.cardBorder),
                    _buildPillarItem(
                      icon: Icons.verified_user_outlined,
                      title: 'Verified Canadian Employers',
                      desc: 'Legitimate corporate, mid-market, and high-growth Canadian firms seeking mature talent.',
                    ),
                    const Divider(height: 20, color: AppConfig.cardBorder),
                    _buildPillarItem(
                      icon: Icons.schedule_rounded,
                      title: 'Flexible Engagement Models',
                      desc: 'Full-time, part-time, advisory boards, fractional roles, and project sprints on your terms.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String description,
    required String actionLabel,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConfig.cardBorder.withOpacity(0.8)),
        boxShadow: AppConfig.modernCardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: AppConfig.primaryNavy,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppConfig.textMuted,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppConfig.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPillarItem({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, color: AppConfig.primaryColor, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppConfig.primaryNavy,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
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
    );
  }
}
