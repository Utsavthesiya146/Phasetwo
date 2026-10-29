import 'package:flutter/material.dart';
import '../config/app_config.dart';
import 'auth/employer_login_screen.dart';
import 'auth/employer_signup_screen.dart';

/// PhaseTwo Option B: Modern Dynamic Employer Section Screen.
/// Dedicated recruitment hub for Canadian enterprises, SMBs, and startups
/// seeking high-caliber senior talent, fractional leaders, and specialized contractors.
class EmployerSectionScreen extends StatelessWidget {
  const EmployerSectionScreen({
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
            // Employer Header Banner (Option B Gradient)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              decoration: const BoxDecoration(
                gradient: AppConfig.heroEmployerGradient,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Color(0x330F2B46),
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
                      color: AppConfig.accentGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppConfig.accentGreen.withOpacity(0.4),
                        width: 0.8,
                      ),
                    ),
                    child: const Text(
                      '🍁 For Canadian Employers & Hiring Teams',
                      style: TextStyle(
                        color: Color(0xFF6EE7B7),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Hire Proven Canadian Talent',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Access experienced executives, seasoned managers, and high-judgment fractional experts ready to drive results with zero ramp-up time.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.88),
                      fontSize: 13.5,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),

            // Top CTA Actions: Post a Job & Pricing
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final Widget postJobBtn = Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: AppConfig.accentGreen.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => onOpenUrl(AppConfig.postJobUrl),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConfig.accentGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                      label: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Post a Role',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                        ),
                      ),
                    ),
                  );

                  final Widget pricingBtn = OutlinedButton.icon(
                    onPressed: () => onOpenUrl(AppConfig.pricingUrl),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppConfig.primaryNavy,
                      side: const BorderSide(color: AppConfig.cardBorder, width: 1.2),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.sell_outlined, size: 18, color: AppConfig.primaryDark),
                    label: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'View Pricing',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                    ),
                  );

                  if (constraints.maxWidth < 300) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        postJobBtn,
                        const SizedBox(height: 8),
                        pricingBtn,
                      ],
                    );
                  }

                  return Row(
                    children: <Widget>[
                      Expanded(child: postJobBtn),
                      const SizedBox(width: 10),
                      Expanded(child: pricingBtn),
                    ],
                  );
                },
              ),
            ),

            // Recruiter Portal Access Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    const Row(
                      children: <Widget>[
                        Icon(Icons.business_center_rounded, color: AppConfig.primaryNavy, size: 22),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Recruiter Console',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppConfig.primaryNavy,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Manage job postings, review applicant profiles, and schedule senior candidate discussions.',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppConfig.textMuted,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),
                    LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        final Widget loginBtn = ElevatedButton(
                          onPressed: () {
                            onOpenUrl(AppConfig.recruiterLoginUrl);
                            if (onAuthSuccess != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EmployerLoginScreen(
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
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Recruiter Login',
                              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
                            ),
                          ),
                        );

                        final Widget registerBtn = OutlinedButton(
                          onPressed: () {
                            onOpenUrl(AppConfig.registerEmployerUrl);
                            if (onAuthSuccess != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EmployerSignupScreen(
                                    onAuthSuccess: onAuthSuccess,
                                  ),
                                ),
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppConfig.primaryNavy,
                            side: const BorderSide(color: AppConfig.cardBorder),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Register Employer',
                              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
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
                  ],
                ),
              ),
            ),

            // Canadian Employer Pricing Tiers Overview
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: const <Widget>[
                        Text(
                          'Employer Listing Plans',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppConfig.primaryNavy,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          'Live Rates',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppConfig.primaryDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Standard Post Tier
                    _buildPricingTierItem(
                      title: 'Standard Opportunity Post',
                      price: 'View on Web',
                      details: 'Active role listing, direct candidate inbox, and Canadian market distribution.',
                      onTap: () => onOpenUrl(AppConfig.pricingUrl),
                    ),
                    const Divider(height: 20, color: AppConfig.cardBorder),

                    // Executive Pack Tier
                    _buildPricingTierItem(
                      title: 'Executive & Fractional Pack',
                      price: 'View on Web',
                      details: 'Featured role placement, targeted senior distribution, and dedicated visibility.',
                      isFeatured: true,
                      onTap: () => onOpenUrl(AppConfig.pricingUrl),
                    ),
                  ],
                ),
              ),
            ),

            // Why Hire PhaseTwo Senior Talent
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
                      'Why Canadian Employers Trust PhaseTwo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppConfig.primaryNavy,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildEmployerPillar(
                      icon: Icons.speed_rounded,
                      title: 'Zero Onboarding Friction',
                      desc: 'Seasoned professionals require minimal supervision and begin delivering on day one.',
                    ),
                    const Divider(height: 20, color: AppConfig.cardBorder),
                    _buildEmployerPillar(
                      icon: Icons.psychology_rounded,
                      title: 'High-Judgment Leadership',
                      desc: 'Proven executive decisions that safeguard company capital, governance, and culture.',
                    ),
                    const Divider(height: 20, color: AppConfig.cardBorder),
                    _buildEmployerPillar(
                      icon: Icons.handshake_outlined,
                      title: 'Cost-Effective Fractional Models',
                      desc: 'Hire C-suite expertise part-time or for targeted advisory sprints without full overhead.',
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

  Widget _buildPricingTierItem({
    required String title,
    required String price,
    required String details,
    bool isFeatured = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppConfig.primaryNavy,
                    ),
                  ),
                  if (isFeatured) ...<Widget>[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppConfig.primaryLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'RECOMMENDED',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: AppConfig.primaryDark,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 3),
                  Text(
                    details,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppConfig.textMuted,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              price,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppConfig.accentGreenDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployerPillar({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, color: AppConfig.accentGreen, size: 20),
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
