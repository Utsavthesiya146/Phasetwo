import 'package:flutter/material.dart';
import '../config/app_config.dart';

/// Professional offline & network error screen with PhaseTwo branding and retry capability.
class WebErrorScreen extends StatefulWidget {
  const WebErrorScreen({
    super.key,
    required this.onRetry,
    this.errorMessage,
    this.isOffline = true,
  });

  final Future<void> Function() onRetry;
  final String? errorMessage;
  final bool isOffline;

  @override
  State<WebErrorScreen> createState() => _WebErrorScreenState();
}

class _WebErrorScreenState extends State<WebErrorScreen> {
  bool _isRetrying = false;

  Future<void> _handleRetry() async {
    if (_isRetrying) return;
    setState(() {
      _isRetrying = true;
    });

    try {
      await widget.onRetry();
    } finally {
      if (mounted) {
        setState(() {
          _isRetrying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // PhaseTwo Logo
                Hero(
                  tag: 'app_logo',
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 48,
                    errorBuilder: (context, error, stackTrace) => const Text(
                      AppConfig.appName,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppConfig.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                // Error Graphic
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: AppConfig.primaryLight.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppConfig.primaryColor.withValues(alpha: 0.12),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.isOffline
                        ? Icons.wifi_off_rounded
                        : Icons.cloud_off_rounded,
                    size: 52,
                    color: AppConfig.primaryDark,
                  ),
                ),
                const SizedBox(height: 28),

                // Headline
                Text(
                  widget.isOffline
                      ? 'No Internet Connection'
                      : 'Connection Failed',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppConfig.textDark,
                    letterSpacing: -0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Subtitle
                Text(
                  widget.isOffline
                      ? 'Please check your Wi-Fi or mobile network connection and tap the button below to reload.'
                      : (widget.errorMessage ??
                          'Unable to reach PhaseTwo servers. Please verify your connection and try again.'),
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.45,
                    color: AppConfig.textMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Retry Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isRetrying ? null : _handleRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConfig.primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: AppConfig.primaryColor.withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: _isRetrying
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.refresh_rounded, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Retry Connection',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 18),

                // Direct Candidate / Employer quick hint
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12, width: 0.8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.info_outline, size: 16, color: AppConfig.textMuted),
                      SizedBox(width: 8),
                      Text(
                        'Connecting experienced talent across Canada',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppConfig.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
