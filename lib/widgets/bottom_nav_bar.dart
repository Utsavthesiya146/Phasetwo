import 'package:flutter/material.dart';
import '../config/app_config.dart';

/// Premium Bottom Navigation Bar for PhaseTwo.
/// Features four equally distributed tabs (Home, Jobs, Candidate, Employer)
/// using short singular labels, independent layout spaces, centered touch targets,
/// and Option B active indicator styling.
class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: AppConfig.cardBorder.withOpacity(0.8),
            width: 0.8,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        bottom: true,
        child: SizedBox(
          height: 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildTabItem(
                context: context,
                index: 0,
                label: 'Home',
                icon: Icons.home_outlined,
                selectedIcon: Icons.home_rounded,
              ),
              _buildTabItem(
                context: context,
                index: 1,
                label: 'Jobs',
                icon: Icons.work_outline_rounded,
                selectedIcon: Icons.work_rounded,
              ),
              _buildTabItem(
                context: context,
                index: 2,
                label: 'Candidate',
                icon: Icons.person_outline_rounded,
                selectedIcon: Icons.person_rounded,
              ),
              _buildTabItem(
                context: context,
                index: 3,
                label: 'Employer',
                icon: Icons.business_outlined,
                selectedIcon: Icons.business_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required BuildContext context,
    required int index,
    required String label,
    required IconData icon,
    required IconData selectedIcon,
  }) {
    final bool isSelected = currentIndex == index;
    // Responsive text scaler clamped safely between 0.85 and 1.20 to avoid vertical overflow under extreme font scaling
    final double textScale =
        MediaQuery.textScalerOf(context).scale(1.0).clamp(0.85, 1.20);
    final double fontSize = (11.0 / textScale).clamp(9.0, 11.5);

    return Expanded(
      child: Semantics(
        button: true,
        selected: isSelected,
        label: '$label tab',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onTap(index),
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Option B Active Top Indicator Pill
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isSelected ? 22 : 0,
                  height: 2.5,
                  margin: const EdgeInsets.only(bottom: 2),
                  decoration: BoxDecoration(
                    color: AppConfig.primaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Icon Container with tactile pill background when active
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppConfig.primaryLight
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isSelected ? selectedIcon : icon,
                    size: 20,
                    color: isSelected
                        ? AppConfig.primaryNavy
                        : const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 1),
                // Centered, independent label with responsive typography
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    label,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    textScaler: TextScaler.linear(textScale),
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? AppConfig.primaryNavy
                          : const Color(0xFF64748B),
                      letterSpacing: -0.2,
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
