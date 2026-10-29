import 'package:flutter/material.dart';
import '../config/app_config.dart';

/// PhaseTwo Option B: Modern Dynamic Home Dashboard.
/// Features Sky Blue gradient hero accents, subtle ambient card elevations,
/// Canadian executive badges, and live hand-offs to persistent WebView sessions.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onNavigateToTab,
    required this.onOpenUrl,
  });

  final void Function(int tabIndex) onNavigateToTab;
  final void Function(String url) onOpenUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundLight,
      body: RefreshIndicator(
        color: AppConfig.primaryColor,
        backgroundColor: Colors.white,
        onRefresh: () async {
          await Future<void>.delayed(const Duration(milliseconds: 400));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Modern Dynamic Hero Banner
              _buildModernHeroSection(context),

              // Quick Search Bar Shortcut
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: _buildQuickSearchBar(context),
              ),

              // Trust & Canadian Market Metrics
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: _buildTrustMetrics(),
              ),

              // Candidate & Employer Dual Portal Action Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: _buildDualPortalCards(),
              ),

              // Curated Canadian Senior Opportunities (Option B High-Density Cards)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: _buildFeaturedOpportunities(context),
              ),

              // "Who PhaseTwo Is For" Experience Focus
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: _buildWhoPhaseTwoIsFor(),
              ),

              // Work Models Supported (Fractional, Interim, Advisory, Flexible Gigs)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: _buildWorkModels(),
              ),

              // Top Executive Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: _buildTopCategories(),
              ),

              // Career Transition Assistance Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: _buildAssistanceCard(context),
              ),

              // Why PhaseTwo Value Highlights
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: _buildWhyPhaseTwoCard(),
              ),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  /// Modern Dynamic Hero Header with PhaseTwo Gradient
  Widget _buildModernHeroSection(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppConfig.heroNavyGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0x330F2B46),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Canadian Pride Frosted Glass Pill
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
          const SizedBox(height: 16),

          // Main Headline
          const Text(
            'Experience Is Your Greatest Asset',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w800,
              height: 1.22,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 10),

          // Subtitle
          Text(
            'Connecting high-judgment professionals with reputable Canadian employers for fractional, contract, and executive roles.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.88),
              fontSize: 13.5,
              height: 1.45,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 22),

          // Action Buttons (Option B Tactile Responsive Styling)
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final Widget findWorkBtn = Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: AppConfig.buttonShadow,
                ),
                child: ElevatedButton.icon(
                  onPressed: () => onNavigateToTab(1),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConfig.primaryColor,
                    foregroundColor: AppConfig.primaryNavy,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.search_rounded, size: 18),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Find Work',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ),
              );

              final Widget postRoleBtn = OutlinedButton.icon(
                onPressed: () => onNavigateToTab(3),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 1.2),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                label: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Post a Role',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              );

              if (constraints.maxWidth < 300) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    findWorkBtn,
                    const SizedBox(height: 8),
                    postRoleBtn,
                  ],
                );
              }

              return Row(
                children: <Widget>[
                  Expanded(child: findWorkBtn),
                  const SizedBox(width: 10),
                  Expanded(child: postRoleBtn),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  /// Quick Search Bar with Ambient Shadow
  Widget _buildQuickSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: () => onNavigateToTab(1),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppConfig.cardBorder.withOpacity(0.8)),
          boxShadow: AppConfig.modernCardShadow,
        ),
        child: Row(
          children: <Widget>[
            const Icon(Icons.search_rounded, color: AppConfig.primaryColor, size: 22),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Search role, skill, or Canadian city...',
                style: TextStyle(
                  fontSize: 13.5,
                  color: AppConfig.textMuted,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppConfig.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'FIND',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppConfig.primaryDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Responsive Talent Principles Banner (Verified Value Pillars - No Unverified Claims)
  Widget _buildTrustMetrics() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isCompact = constraints.maxWidth < 360;

        return Container(
          padding: EdgeInsets.symmetric(
            vertical: isCompact ? 10 : 12,
            horizontal: isCompact ? 6 : 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppConfig.cardBorder.withOpacity(0.8)),
            boxShadow: AppConfig.modernCardShadow,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: _buildMetricItem(
                  icon: Icons.workspace_premium_rounded,
                  title: 'Experienced',
                  subtitle: 'Senior Focus',
                ),
              ),
              Container(width: 1, height: 26, color: AppConfig.cardBorder),
              Expanded(
                child: _buildMetricItem(
                  icon: Icons.handshake_rounded,
                  title: 'High-Judgment',
                  subtitle: 'Direct Match',
                ),
              ),
              Container(width: 1, height: 26, color: AppConfig.cardBorder),
              Expanded(
                child: _buildMetricItem(
                  icon: Icons.tune_rounded,
                  title: 'Flexible',
                  subtitle: 'Fractional & Gigs',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 17, color: AppConfig.primaryColor),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppConfig.primaryNavy,
                letterSpacing: -0.2,
              ),
            ),
          ),
          const SizedBox(height: 1),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              subtitle,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 10,
                color: AppConfig.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Dual Portal Cards (Candidates & Employers)
  Widget _buildDualPortalCards() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Widget candidateCard = InkWell(
          onTap: () => onNavigateToTab(2),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppConfig.primaryColor.withOpacity(0.3)),
              boxShadow: AppConfig.modernCardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppConfig.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppConfig.primaryDark,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Candidates',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: AppConfig.primaryNavy,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Phase 2 careers, returners & fractional leadership',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppConfig.textMuted,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                const Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Open Hub',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: AppConfig.primaryDark,
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded, size: 12, color: AppConfig.primaryDark),
                  ],
                ),
              ],
            ),
          ),
        );

        final Widget employerCard = InkWell(
          onTap: () => onNavigateToTab(3),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppConfig.accentGreen.withOpacity(0.3)),
              boxShadow: AppConfig.modernCardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppConfig.accentGreenLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.business_center_rounded,
                    color: AppConfig.accentGreenDark,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Employers',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: AppConfig.primaryNavy,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Hire proven, verified Canadian talent',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppConfig.textMuted,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                const Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Recruiter Hub',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: AppConfig.accentGreenDark,
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded, size: 12, color: AppConfig.accentGreenDark),
                  ],
                ),
              ],
            ),
          ),
        );

        if (constraints.maxWidth < 340) {
          return Column(
            children: <Widget>[
              candidateCard,
              const SizedBox(height: 10),
              employerCard,
            ],
          );
        }

        return Row(
          children: <Widget>[
            Expanded(child: candidateCard),
            const SizedBox(width: 10),
            Expanded(child: employerCard),
          ],
        );
      },
    );
  }

  /// Featured Canadian Senior Opportunities (Option B High-Density Cards)
  Widget _buildFeaturedOpportunities(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: <Widget>[
            const Text(
              'Featured Opportunities',
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                color: AppConfig.primaryNavy,
                letterSpacing: -0.4,
              ),
            ),
            GestureDetector(
              onTap: () => onNavigateToTab(1),
              child: const Text(
                'Explore All →',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppConfig.primaryDark,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Role Track 1: Executive Operations & Supply Chain
        _buildOpportunityCard(
          title: 'Fractional VP & COO Roles',
          company: 'Operations & Supply Leadership',
          location: 'Toronto, ON & Nationwide · Hybrid',
          workType: 'Fractional',
          seniority: '15+ Years Exp',
          searchQuery: 'Operations',
        ),

        // Role Track 2: Corporate Governance & Advisory
        _buildOpportunityCard(
          title: 'Interim Corporate Governance & Board Advisory',
          company: 'Governance, Legal & Compliance',
          location: 'Montreal, QC & Nationwide · Hybrid',
          workType: 'Contract',
          seniority: 'Executive (20+)',
          searchQuery: 'Governance',
        ),

        // Role Track 3: Technology Architecture & AI Strategy
        _buildOpportunityCard(
          title: 'Senior Enterprise & AI Technology Advisory',
          company: 'Digital Architecture & Technology',
          location: 'Vancouver, BC & Remote Canada',
          workType: 'Consulting',
          seniority: '10+ Years Exp',
          searchQuery: 'Technology',
        ),
      ],
    );
  }

  /// Option B High-Density Job Card with Soft Ambient Shadow
  Widget _buildOpportunityCard({
    required String title,
    required String company,
    required String location,
    required String workType,
    required String seniority,
    required String searchQuery,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConfig.cardBorder.withOpacity(0.8)),
        boxShadow: AppConfig.modernCardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onOpenUrl('${AppConfig.jobsUrl}?search=$searchQuery'),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppConfig.backgroundLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppConfig.cardBorder),
                      ),
                      child: Center(
                        child: Text(
                          company.isNotEmpty ? company.substring(0, 1) : 'P',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppConfig.primaryNavy,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            company,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: AppConfig.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            location,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppConfig.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: AppConfig.textMuted,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppConfig.primaryNavy,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppConfig.primaryLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        workType,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppConfig.primaryDark,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppConfig.backgroundLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppConfig.cardBorder),
                      ),
                      child: Text(
                        seniority,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppConfig.textSecondary,
                        ),
                      ),
                    ),
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Search Live',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: AppConfig.primaryDark,
                          ),
                        ),
                        SizedBox(width: 3),
                        Icon(Icons.arrow_forward_rounded, size: 12, color: AppConfig.primaryDark),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// "Who PhaseTwo Is For" Section
  Widget _buildWhoPhaseTwoIsFor() {
    return Container(
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
              Icon(Icons.stars_rounded, color: AppConfig.primaryColor, size: 22),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Who PhaseTwo Is For',
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
          const SizedBox(height: 14),
          _buildAudienceRow(
            icon: Icons.trending_up_rounded,
            title: 'Experienced & Mature Professionals (10+ Years)',
            subtitle: 'You have decades of deep domain wisdom and high judgment.',
          ),
          const Divider(height: 20, color: AppConfig.cardBorder),
          _buildAudienceRow(
            icon: Icons.restart_alt_rounded,
            title: 'Career Returners & Transitions',
            subtitle: 'Re-entering the Canadian workforce with renewed purpose and flexibility.',
          ),
          const Divider(height: 20, color: AppConfig.cardBorder),
          _buildAudienceRow(
            icon: Icons.shield_outlined,
            title: 'Canadian Employers & Recruiters',
            subtitle: 'Seeking verified, reliable leaders who deliver immediate institutional value.',
          ),
        ],
      ),
    );
  }

  Widget _buildAudienceRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppConfig.primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppConfig.primaryDark, size: 18),
        ),
        const SizedBox(width: 12),
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
                subtitle,
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

  /// Work Models Supported
  Widget _buildWorkModels() {
    final List<Map<String, dynamic>> models = <Map<String, dynamic>>[
      <String, dynamic>{'title': 'Fractional Leadership', 'icon': Icons.pie_chart_outline_rounded},
      <String, dynamic>{'title': 'Interim Executive', 'icon': Icons.admin_panel_settings_outlined},
      <String, dynamic>{'title': 'Consulting & Advisory', 'icon': Icons.lightbulb_outline_rounded},
      <String, dynamic>{'title': 'Flexible Gigs', 'icon': Icons.electric_bolt_rounded},
      <String, dynamic>{'title': 'Direct Placement', 'icon': Icons.verified_user_outlined},
    ];

    return Container(
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
            'Work Models We Support',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppConfig.primaryNavy,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: models.map((model) {
              return InkWell(
                onTap: () => onOpenUrl(AppConfig.gigsUrl),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppConfig.backgroundLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppConfig.cardBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(model['icon'] as IconData, size: 15, color: AppConfig.primaryDark),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          model['title'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppConfig.primaryNavy,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Top Canadian Executive Categories
  Widget _buildTopCategories() {
    final List<Map<String, String>> categories = <Map<String, String>>[
      <String, String>{'title': 'Executive & Governance', 'search': 'Executive'},
      <String, String>{'title': 'Operations & Supply Chain', 'search': 'Operations'},
      <String, String>{'title': 'Finance & Capital Advisory', 'search': 'Finance'},
      <String, String>{'title': 'Technology Architecture', 'search': 'Technology'},
      <String, String>{'title': 'Human Resources & People', 'search': 'HR'},
      <String, String>{'title': 'Healthcare & Non-Profit', 'search': 'Healthcare'},
    ];

    return Container(
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
            'Explore Top Categories',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppConfig.primaryNavy,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(height: 12, color: AppConfig.cardBorder),
            itemBuilder: (BuildContext context, int index) {
              final cat = categories[index];
              return InkWell(
                onTap: () => onOpenUrl('${AppConfig.jobsUrl}?search=${cat['search']}'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          cat['title']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppConfig.textDark,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: AppConfig.textMuted,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Career Assistance Banner
  Widget _buildAssistanceCard(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isNarrow = constraints.maxWidth < 320;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: <Color>[Color(0xFF0F2B46), Color(0xFF0369A1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppConfig.modernCardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.support_agent_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Need Career Guidance?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'PhaseTwo provides personalized resume support & guidance.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 11.5,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isNarrow) ...<Widget>[
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => onOpenUrl(AppConfig.assistanceUrl),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConfig.primaryColor,
                        foregroundColor: AppConfig.primaryNavy,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Get Help',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ],
              ),
              if (isNarrow) ...<Widget>[
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => onOpenUrl(AppConfig.assistanceUrl),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConfig.primaryColor,
                    foregroundColor: AppConfig.primaryNavy,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Get Help',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  /// Why PhaseTwo Value Highlights
  Widget _buildWhyPhaseTwoCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConfig.cardBorder.withOpacity(0.8)),
        boxShadow: AppConfig.modernCardShadow,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'The PhaseTwo Promise',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppConfig.primaryNavy,
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Canada\'s specialized employment and consulting ecosystem dedicated to valuing career wisdom. We bridge senior talent seeking flexible, impactful work with Canadian employers seeking proven leaders.',
            style: TextStyle(
              fontSize: 12.5,
              color: AppConfig.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
