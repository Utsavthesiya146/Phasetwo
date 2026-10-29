import 'package:flutter/material.dart';
import '../config/app_config.dart';

/// PhaseTwo Option B: Modern Dynamic Job Search & Filter Entry Screen.
/// Provides dual-field search (keywords & Canadian city), interactive filter chips,
/// fast category access, and high-density opportunity cards routing to persistent WebView.
class JobsScreen extends StatefulWidget {
  const JobsScreen({
    super.key,
    required this.onOpenUrl,
  });

  final void Function(String url) onOpenUrl;

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final TextEditingController _keywordController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String _selectedJobType = 'All Types';
  String _selectedExpLevel = 'All';

  final List<String> _jobTypes = <String>[
    'All Types',
    'Fractional',
    'Flexible Gig',
    'Part-Time',
    'Contract',
    'Full-Time',
  ];

  final List<String> _expLevels = <String>[
    'All',
    '10+ Years',
    '15+ Years',
    'Executive (20+)',
  ];

  final List<String> _quickLocations = <String>[
    'Remote Canada',
    'Toronto, ON',
    'Vancouver, BC',
    'Montreal, QC',
    'Calgary, AB',
    'Ottawa, ON',
  ];

  @override
  void dispose() {
    _keywordController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _executeSearch() {
    final String keyword = _keywordController.text.trim();
    final String location = _locationController.text.trim();

    // Construct search URL for live PhaseTwo web platform
    final Uri baseUri = Uri.parse(AppConfig.jobsUrl);
    final Map<String, String> params = <String, String>{};

    if (keyword.isNotEmpty) {
      params['search'] = keyword;
    }
    if (location.isNotEmpty) {
      params['city'] = location;
    }

    final String finalUrl = params.isEmpty
        ? AppConfig.jobsUrl
        : baseUri.replace(queryParameters: params).toString();

    widget.onOpenUrl(finalUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundLight,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Search Header Banner (Option B Gradient)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      '🍁 Canadian Senior Talent Network',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Search Jobs & Flexible Gigs',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Discover fractional leadership, executive advisory, and flexible opportunities across Canada.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            // Main Search Card Container (Option B Ambient Shadow)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
                    // Keyword / Designation Input
                    const Text(
                      'Keywords / Designations',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppConfig.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _keywordController,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'e.g. Director, VP, Advisor, Operations...',
                        hintStyle: const TextStyle(fontSize: 13, color: AppConfig.textMuted),
                        prefixIcon: const Icon(Icons.search_rounded, color: AppConfig.primaryColor, size: 20),
                        suffixIcon: _keywordController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18),
                                onPressed: () {
                                  setState(() {
                                    _keywordController.clear();
                                  });
                                },
                              )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppConfig.cardBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppConfig.cardBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppConfig.primaryColor, width: 1.5),
                        ),
                        filled: true,
                        fillColor: AppConfig.backgroundLight,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // City / Canadian Location Input
                    const Text(
                      'Canadian Province / City',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppConfig.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _locationController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _executeSearch(),
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'e.g. Toronto, Vancouver, Calgary, Remote...',
                        hintStyle: const TextStyle(fontSize: 13, color: AppConfig.textMuted),
                        prefixIcon: const Icon(Icons.location_on_outlined, color: AppConfig.primaryColor, size: 20),
                        suffixIcon: _locationController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18),
                                onPressed: () {
                                  setState(() {
                                    _locationController.clear();
                                  });
                                },
                              )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppConfig.cardBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppConfig.cardBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppConfig.primaryColor, width: 1.5),
                        ),
                        filled: true,
                        fillColor: AppConfig.backgroundLight,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Quick Location Pills
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _quickLocations.map((String loc) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _locationController.text = loc;
                            });
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppConfig.backgroundLight,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppConfig.cardBorder),
                            ),
                            child: Text(
                              loc,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppConfig.textSecondary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Job Type Filter Chips
                    const Text(
                      'Engagement Type',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppConfig.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _jobTypes.map((String type) {
                        final bool isSelected = _selectedJobType == type;
                        return ChoiceChip(
                          label: Text(type),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            setState(() {
                              _selectedJobType = selected ? type : 'All Types';
                            });
                          },
                          selectedColor: AppConfig.primaryColor,
                          backgroundColor: AppConfig.backgroundLight,
                          labelStyle: TextStyle(
                            fontSize: 11.5,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                            color: isSelected ? AppConfig.primaryNavy : AppConfig.textDark,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected ? AppConfig.primaryColor : AppConfig.cardBorder,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),

                    // Experience Level Filter Chips
                    const Text(
                      'Experience Level',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppConfig.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _expLevels.map((String level) {
                        final bool isSelected = _selectedExpLevel == level;
                        return ChoiceChip(
                          label: Text(level),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            setState(() {
                              _selectedExpLevel = selected ? level : 'All';
                            });
                          },
                          selectedColor: AppConfig.primaryLight,
                          backgroundColor: AppConfig.backgroundLight,
                          labelStyle: TextStyle(
                            fontSize: 11.5,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                            color: isSelected ? AppConfig.primaryDark : AppConfig.textDark,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected ? AppConfig.primaryDark : AppConfig.cardBorder,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Search Button (Option B Button Glow)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: AppConfig.buttonShadow,
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _executeSearch,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConfig.primaryColor,
                          foregroundColor: AppConfig.primaryNavy,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.search_rounded, size: 20),
                        label: const Text(
                          'Search on PhaseTwo Live',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Direct Search Shortcuts (Flexible Gigs, Live Remote)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final Widget gigsBtn = OutlinedButton.icon(
                    onPressed: () => widget.onOpenUrl(AppConfig.gigsUrl),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppConfig.primaryNavy,
                      side: BorderSide(color: AppConfig.primaryColor.withOpacity(0.5)),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.flash_on_rounded, size: 16, color: AppConfig.primaryColor),
                    label: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Browse Gigs',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
                      ),
                    ),
                  );

                  final Widget remoteBtn = OutlinedButton.icon(
                    onPressed: () => widget.onOpenUrl('${AppConfig.jobsUrl}?search=remote'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppConfig.primaryNavy,
                      side: const BorderSide(color: AppConfig.cardBorder),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.public_rounded, size: 16, color: AppConfig.primaryDark),
                    label: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Remote Canada',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
                      ),
                    ),
                  );

                  if (constraints.maxWidth < 300) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        gigsBtn,
                        const SizedBox(height: 8),
                        remoteBtn,
                      ],
                    );
                  }

                  return Row(
                    children: <Widget>[
                      Expanded(child: gigsBtn),
                      const SizedBox(width: 10),
                      Expanded(child: remoteBtn),
                    ],
                  );
                },
              ),
            ),

            // Featured Role Cards Linking Directly to Live Website
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Popular Senior Role Searches',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppConfig.primaryNavy,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildLiveJobCard(
                    title: 'Fractional Chief Operating Officer',
                    location: 'Toronto, ON · Hybrid',
                    engagement: 'Fractional',
                    seniority: '15+ Years',
                    searchParam: 'Operations',
                  ),
                  _buildLiveJobCard(
                    title: 'Interim Senior Director of HR',
                    location: 'Ottawa, ON · Hybrid',
                    engagement: 'Contract',
                    seniority: '12+ Years',
                    searchParam: 'HR',
                  ),
                  _buildLiveJobCard(
                    title: 'Strategic Financial Consultant',
                    location: 'Calgary, AB · On-site',
                    engagement: 'Flexible Gig',
                    seniority: 'Executive',
                    searchParam: 'Finance',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveJobCard({
    required String title,
    required String location,
    required String engagement,
    required String seniority,
    required String searchParam,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppConfig.cardBorder.withOpacity(0.8)),
        boxShadow: AppConfig.modernCardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onOpenUrl('${AppConfig.jobsUrl}?search=$searchParam'),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: <Widget>[
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppConfig.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.work_outline_rounded,
                    color: AppConfig.primaryDark,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
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
                      const SizedBox(height: 3),
                      Text(
                        location,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppConfig.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppConfig.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppConfig.cardBorder),
                  ),
                  child: Text(
                    engagement,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: AppConfig.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
