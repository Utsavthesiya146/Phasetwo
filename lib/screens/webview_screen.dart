import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../config/app_config.dart';
import '../services/network_service.dart';
import '../services/url_handler_service.dart';
import '../widgets/progress_bar.dart';
import 'auth/candidate_login_screen.dart';
import 'auth/candidate_signup_screen.dart';
import 'auth/employer_login_screen.dart';
import 'auth/employer_signup_screen.dart';
import 'auth/forgot_password_screen.dart';
import 'error_screen.dart';

/// Main production WebView screen for PhaseTwo.
class PhaseTwoWebViewScreen extends StatefulWidget {
  const PhaseTwoWebViewScreen({
    super.key,
    this.initialUrl = AppConfig.initialUrl,
    this.onReturnHome,
    this.onClose,
    this.onProgressChanged,
    this.onLoadingChanged,
    this.onUrlChanged,
    this.onCanGoBackChanged,
    this.onAuthSignalDetected,
    this.showAppBar = false,
  });

  final String initialUrl;
  final VoidCallback? onReturnHome;
  final VoidCallback? onClose;
  final ValueChanged<double>? onProgressChanged;
  final ValueChanged<bool>? onLoadingChanged;
  final ValueChanged<String>? onUrlChanged;
  final ValueChanged<bool>? onCanGoBackChanged;
  final void Function(String jsonResult, String url)? onAuthSignalDetected;
  final bool showAppBar;

  @override
  PhaseTwoWebViewScreenState createState() => PhaseTwoWebViewScreenState();
}

class PhaseTwoWebViewScreenState extends State<PhaseTwoWebViewScreen> {
  late final WebViewController _controller;
  final NetworkService _networkService = NetworkService();

  double _loadingProgress = 0.0;
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;
  bool _canGoBack = false;
  bool _canGoForward = false;
  String _currentUrl = AppConfig.initialUrl;
  bool _isControllerReady = false;
  String? _pendingUrl;

  @override
  void didUpdateWidget(PhaseTwoWebViewScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialUrl != oldWidget.initialUrl &&
        widget.initialUrl.isNotEmpty &&
        widget.initialUrl != _currentUrl) {
      loadPage(widget.initialUrl);
    }
  }

  /// Loads a new URL without destroying controller or session state
  Future<void> loadPage(String url) async {
    if (url.isEmpty) return;
    _currentUrl = url;
    if (!_isControllerReady) {
      _pendingUrl = url;
      return;
    }
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
    });
    try {
      await _controller.loadRequest(Uri.parse(url));
    } catch (e) {
      debugPrint('[WebView] Load URL error: $e');
    }
  }

  /// Reloads the current page
  Future<void> reload() async {
    await _reloadCurrentPage();
  }

  /// Handles back button navigation inside the WebView history
  Future<bool> handleBack() async {
    try {
      if (await _controller.canGoBack()) {
        await _controller.goBack();
        return true;
      }
    } catch (_) {}
    return false;
  }

  /// Checks if WebView can navigate back
  Future<bool> canGoBack() async {
    try {
      return await _controller.canGoBack();
    } catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _initWebViewController();
    _listenToConnectivity();
  }

  void _initWebViewController() {
    final String targetUrl = _pendingUrl ??
        (widget.initialUrl.isNotEmpty
            ? widget.initialUrl
            : AppConfig.initialUrl);
    _pendingUrl = null;
    _currentUrl = targetUrl;

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setUserAgent(
        'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36 PhaseTwoApp/1.0',
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (!mounted) return;
            final double prog = progress / 100.0;
            final bool loading = progress < 100;
            setState(() {
              _loadingProgress = prog;
              _isLoading = loading;
            });
            widget.onProgressChanged?.call(prog);
            widget.onLoadingChanged?.call(loading);
          },
          onPageStarted: (String url) {
            debugPrint('[WebView] Page started loading: $url');
            if (!mounted) return;
            setState(() {
              _currentUrl = url;
              _isLoading = true;
              _hasError = false;
              _errorMessage = null;
            });
            widget.onUrlChanged?.call(url);
            widget.onLoadingChanged?.call(true);
            _updateNavigationButtons();
          },
          onPageFinished: (String url) async {
            debugPrint('[WebView] Page finished loading: $url');
            if (!mounted) return;
            setState(() {
              _currentUrl = url;
              _isLoading = false;
            });
            widget.onLoadingChanged?.call(false);
            _updateNavigationButtons();

            // Run JS DOM check for authentic session indicators
            try {
              final Object result = await controller.runJavaScriptReturningResult('''
                (function() {
                  try {
                    var hasLogout = !!document.querySelector('a[href*="logout" i], a[href*="Logout" i], form[action*="logout" i]');
                    var isEmployer = !!document.querySelector('a[href*="company" i], a[href*="recruiter" i], a[href*="New_job_post" i]');
                    var isCandidate = !!document.querySelector('a[href*="candidate" i], a[href*="applied" i]');
                    return JSON.stringify({
                      hasLogout: hasLogout,
                      isEmployer: isEmployer,
                      isCandidate: isCandidate,
                      url: window.location.href
                    });
                  } catch(e) {
                    return JSON.stringify({ error: e.toString() });
                  }
                })();
              ''');
              if (result.toString().isNotEmpty) {
                widget.onAuthSignalDetected?.call(result.toString(), url);
              }
            } catch (e) {
              debugPrint('[WebView] Auth signal detection error: $e');
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint(
              '[WebView] Resource error: ${error.errorCode} - ${error.description} (isMainFrame: ${error.isForMainFrame})',
            );
            // Only show full error screen if error is on the main frame navigation
            if (error.isForMainFrame ?? true) {
              if (!mounted) return;
              setState(() {
                _hasError = true;
                _errorMessage = error.description;
                _isLoading = false;
              });
            }
          },
          onNavigationRequest: (NavigationRequest request) async {
            final Uri uri = Uri.parse(request.url);
            debugPrint('[WebView] Navigation request to: ${request.url}');

            // 1. Handle special device schemes: mailto:, tel:, sms:, whatsapp:
            if (UrlHandlerService.isSpecialScheme(uri)) {
              await UrlHandlerService.launchExternal(request.url);
              return NavigationDecision.prevent;
            }

            // 2. Handle file downloads (.pdf, .doc, .xlsx, .zip, etc.)
            if (UrlHandlerService.isDownloadUrl(uri)) {
              await UrlHandlerService.launchExternal(request.url);
              _showSnackBar('Opening download in browser/system manager...');
              return NavigationDecision.prevent;
            }

            // 3. Handle external social media links (LinkedIn, Facebook, X, etc.)
            if (UrlHandlerService.isSocialOrExternalLink(uri)) {
              await UrlHandlerService.launchExternal(request.url);
              return NavigationDecision.prevent;
            }

            // 4. Intercept authentication URLs - open native Flutter auth screens
            if (UrlHandlerService.isAuthUrl(uri)) {
              if (UrlHandlerService.isCandidateLoginUrl(uri)) {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const CandidateLoginScreen(),
                  ),
                );
              } else if (UrlHandlerService.isEmployerLoginUrl(uri)) {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const EmployerLoginScreen(),
                  ),
                );
              } else if (UrlHandlerService.isCandidateRegisterUrl(uri)) {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const CandidateSignupScreen(),
                  ),
                );
              } else if (UrlHandlerService.isEmployerRegisterUrl(uri)) {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const EmployerSignupScreen(),
                  ),
                );
              } else if (UrlHandlerService.isForgotPasswordUrl(uri)) {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const ForgotPasswordScreen(),
                  ),
                );
              }
              return NavigationDecision.prevent;
            }

            // 5. Intercept PhaseTwo homepage navigation inside WebView
            if (UrlHandlerService.isHomePageUrl(uri)) {
              if (widget.onClose != null) {
                widget.onClose!();
              } else {
                widget.onReturnHome?.call();
              }
              return NavigationDecision.prevent;
            }

            // 6. Handle internal PhaseTwo URLs and Payment/Auth Gateways
            if (UrlHandlerService.isInternalUrl(uri)) {
              return NavigationDecision.navigate;
            }

            // 7. Fallback for any other external links: open in external browser
            await UrlHandlerService.launchExternal(request.url);
            return NavigationDecision.prevent;
          },
        ),
      );

    // Platform-specific enhancements
    if (controller.platform is AndroidWebViewController) {
      final AndroidWebViewController androidController =
          controller.platform as AndroidWebViewController;
      AndroidWebViewController.enableDebugging(kDebugMode);
      androidController.setMediaPlaybackRequiresUserGesture(false);
    } else if (controller.platform is WebKitWebViewController) {
      final WebKitWebViewController iOSController =
          controller.platform as WebKitWebViewController;
      iOSController.setAllowsBackForwardNavigationGestures(true);
    }

    _controller = controller;
    _isControllerReady = true;
    _controller.loadRequest(Uri.parse(targetUrl));
  }

  void _listenToConnectivity() {
    _networkService.isConnectedNotifier.addListener(() {
      final bool isConnected = _networkService.isConnectedNotifier.value;
      if (isConnected && _hasError) {
        debugPrint('[WebView] Network restored, auto-retrying page load...');
        _reloadCurrentPage();
      }
    });
  }

  Future<void> _updateNavigationButtons() async {
    final bool canBack = await _controller.canGoBack();
    final bool canForward = await _controller.canGoForward();
    if (!mounted) return;
    setState(() {
      _canGoBack = canBack;
      _canGoForward = canForward;
    });
    widget.onCanGoBackChanged?.call(canBack);
  }

  Future<void> _reloadCurrentPage() async {
    final bool hasNet = await _networkService.checkConnection();
    if (!hasNet) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _errorMessage = 'No active internet connection found.';
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      _hasError = false;
      _errorMessage = null;
      _isLoading = true;
    });

    if (_currentUrl.isEmpty || _currentUrl == 'about:blank') {
      await _controller.loadRequest(Uri.parse(AppConfig.initialUrl));
    } else {
      await _controller.reload();
    }
  }

  Future<bool> _onWillPop() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return false;
    }

    if (!mounted) return false;

    // Prompt user before exiting application
    final bool? exitApp = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: <Widget>[
              Icon(Icons.exit_to_app, color: AppConfig.primaryColor),
              SizedBox(width: 8),
              Text('Exit PhaseTwo?'),
            ],
          ),
          content: const Text(
            'Are you sure you want to exit the application?',
            style: TextStyle(fontSize: 15, color: AppConfig.textMuted),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConfig.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );

    return exitApp ?? false;
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppConfig.textDark,
      ),
    );
  }

  void _showQuickNavigationSheet() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Quick Navigation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConfig.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.home_outlined, color: AppConfig.primaryNavy),
                  title: const Text('Home Dashboard (Native)'),
                  onTap: () {
                    Navigator.pop(context);
                    if (widget.onClose != null) {
                      widget.onClose!();
                    } else {
                      widget.onReturnHome?.call();
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.work_outline, color: AppConfig.primaryNavy),
                  title: const Text('Browse Jobs & Gigs'),
                  onTap: () {
                    Navigator.pop(context);
                    _controller.loadRequest(Uri.parse(AppConfig.jobsUrl));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_outline, color: AppConfig.primaryNavy),
                  title: const Text('Candidate Sign In (Native)'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const CandidateLoginScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.business_outlined, color: AppConfig.primaryNavy),
                  title: const Text('Employer Sign In (Native)'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const EmployerLoginScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _networkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget contentBody = Stack(
      children: <Widget>[
        // Main WebView with pull-to-refresh
        if (!_hasError)
          RefreshIndicator(
            color: AppConfig.primaryColor,
            backgroundColor: Colors.white,
            onRefresh: _reloadCurrentPage,
            child: WebViewWidget(controller: _controller),
          ),

        // Error / Offline Screen Overlay
        if (_hasError)
          WebErrorScreen(
            onRetry: _reloadCurrentPage,
            errorMessage: _errorMessage,
            isOffline: !_networkService.isConnectedNotifier.value,
          ),
      ],
    );

    // If standalone appbar is disabled, return clean content
    if (!widget.showAppBar) {
      return SafeArea(
        top: false,
        bottom: true,
        child: contentBody,
      );
    }

    // Standalone Scaffold if showAppBar is requested
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        final bool shouldExit = await _onWillPop();
        if (shouldExit && mounted) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            titleSpacing: 12,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: _canGoBack ? AppConfig.textDark : Colors.grey.shade400,
              ),
              onPressed: _canGoBack
                  ? () async {
                      if (await _controller.canGoBack()) {
                        await _controller.goBack();
                      }
                    }
                  : null,
              tooltip: 'Go Back',
            ),
            title: Row(
              children: <Widget>[
                Image.asset(
                  'assets/images/logo.png',
                  height: 28,
                  errorBuilder: (context, error, stackTrace) => const Text(
                    AppConfig.appName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConfig.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              if (widget.onReturnHome != null)
                IconButton(
                  icon: const Icon(
                    Icons.home_outlined,
                    size: 22,
                    color: AppConfig.primaryNavy,
                  ),
                  onPressed: widget.onReturnHome,
                  tooltip: 'Return to Native Home',
                ),
              IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 20,
                  color: _canGoForward ? AppConfig.textDark : Colors.grey.shade400,
                ),
                onPressed: _canGoForward
                    ? () async {
                        if (await _controller.canGoForward()) {
                          await _controller.goForward();
                        }
                      }
                    : null,
                tooltip: 'Go Forward',
              ),
              IconButton(
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 22,
                  color: AppConfig.textDark,
                ),
                onPressed: _reloadCurrentPage,
                tooltip: 'Refresh',
              ),
              IconButton(
                icon: const Icon(
                  Icons.menu_rounded,
                  size: 22,
                  color: AppConfig.textDark,
                ),
                onPressed: _showQuickNavigationSheet,
                tooltip: 'Quick Menu',
              ),
              const SizedBox(width: 4),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(3.5),
              child: WebProgressBar(
                progress: _loadingProgress,
                isVisible: _isLoading,
              ),
            ),
          ),
        ),
        body: SafeArea(
          bottom: true,
          top: false,
          child: contentBody,
        ),
      ),
    );
  }
}
