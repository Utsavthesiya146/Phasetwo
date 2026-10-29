import 'package:flutter/material.dart';
import '../config/app_config.dart';

/// Sleek animated loading bar reflecting WebView page load progress.
class WebProgressBar extends StatelessWidget {
  const WebProgressBar({
    super.key,
    required this.progress,
    required this.isVisible,
  });

  /// Progress value between 0.0 and 1.0
  final double progress;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      child: isVisible
          ? SizedBox(
              height: 3.5,
              child: LinearProgressIndicator(
                value: progress > 0.05 ? progress : null,
                backgroundColor: AppConfig.primaryLight.withValues(alpha: 0.4),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppConfig.primaryColor,
                ),
              ),
            )
          : const SizedBox(height: 3.5),
    );
  }
}
