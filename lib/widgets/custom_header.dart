import 'package:flutter/material.dart';
import '../config/app_config.dart';

/// Modern App Header for PhaseTwo with branding and quick shortcuts.
class CustomAppHeader extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppHeader({
    super.key,
    required this.onOpenDrawer,
    required this.onOpenSearch,
    this.onOpenPortal,
    this.onRefresh,
    this.title,
    this.showBack = false,
    this.onBack,
  });

  final VoidCallback onOpenDrawer;
  final VoidCallback onOpenSearch;
  final VoidCallback? onOpenPortal;
  final VoidCallback? onRefresh;
  final String? title;
  final bool showBack;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 0,
      leading: showBack
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: AppConfig.textDark,
              ),
              onPressed: onBack,
              tooltip: 'Back',
            )
          : IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppConfig.backgroundLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppConfig.cardBorder,
                    width: 0.8,
                  ),
                ),
                child: const Icon(
                  Icons.menu_rounded,
                  size: 20,
                  color: AppConfig.primaryNavy,
                ),
              ),
              onPressed: onOpenDrawer,
              tooltip: 'Open Menu',
            ),
      title: title != null
          ? Text(
              title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppConfig.textDark,
                letterSpacing: -0.3,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 28,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Text(
                      AppConfig.appName,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: AppConfig.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppConfig.primaryLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '🍁 CA',
                    style: TextStyle(
                      color: AppConfig.primaryDark,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
      actions: <Widget>[
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppConfig.backgroundLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppConfig.cardBorder,
                width: 0.8,
              ),
            ),
            child: const Icon(
              Icons.search_rounded,
              size: 20,
              color: AppConfig.primaryNavy,
            ),
          ),
          onPressed: onOpenSearch,
          tooltip: 'Search Jobs',
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: AppConfig.cardBorder.withOpacity(0.6),
          height: 1.0,
        ),
      ),
    );
  }
}
