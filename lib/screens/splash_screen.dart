import 'dart:async';
import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../services/auth_session_service.dart';
import 'main_shell.dart';

/// PhaseTwo Branded Splash Screen.
/// Displayed on app startup. Checks verified website authentication state
/// before navigating to the approved Modern Dynamic Home Dashboard (if authenticated)
/// or the native Authentication Welcome Screen (if unauthenticated).
class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    this.minimumDuration = const Duration(milliseconds: 700),
    this.onInitComplete,
  });

  final Duration minimumDuration;
  final VoidCallback? onInitComplete;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndProceed();
  }

  Future<void> _checkAuthAndProceed() async {
    final Stopwatch stopwatch = Stopwatch()..start();

    // Check actual verified session state from persistent storage
    final bool isAuth = await AuthSessionService.instance.init();

    // Ensure splash is visible for minimum duration for smooth branded experience
    final int elapsed = stopwatch.elapsedMilliseconds;
    final int remaining = widget.minimumDuration.inMilliseconds - elapsed;
    if (remaining > 0) {
      await Future<void>.delayed(Duration(milliseconds: remaining));
    }

    if (!mounted) return;

    if (widget.onInitComplete != null) {
      widget.onInitComplete!();
    } else {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder<void>(
          pageBuilder: (context, animation, secondaryAnimation) => MainShellScreen(
            initialAuthenticated: isAuth,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 250),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.primaryNavy,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: AppConfig.heroNavyGradient,
            ),
          ),
          // Centered Brand Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 38,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Text(
                      AppConfig.appName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppConfig.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '🍁 Canada\'s Executive & Senior Talent Network',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Experience Is Your Greatest Asset',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 36),
                const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppConfig.primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
