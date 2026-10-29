import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/app_config.dart';
import '../services/auth_api_service.dart';
import '../services/auth_session_service.dart';
import '../widgets/app_drawer.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_header.dart';
import '../widgets/progress_bar.dart';
import '../services/url_handler_service.dart';
import 'auth/candidate_login_screen.dart';
import 'auth/candidate_signup_screen.dart';
import 'auth/employer_login_screen.dart';
import 'auth/employer_signup_screen.dart';
import 'auth/forgot_password_screen.dart';
import 'auth_welcome_screen.dart';
import 'candidate_section_screen.dart';
import 'employer_section_screen.dart';
import 'home_screen.dart';
import 'jobs_screen.dart';
import 'webview_screen.dart';

/// Main unified mobile shell for PhaseTwo.
/// Hosts the approved Option B Modern Dynamic native screens:
/// - Tab 0: Native Modern Dynamic Home Dashboard
/// - Tab 1: Native Modern Dynamic Job Search UI
/// - Tab 2: Native Candidate Portal Screen
/// - Tab 3: Native Employer Portal Screen
/// Integrates a persistent in-app WebView for actual website-dependent functionality
/// (live search, logins, registrations, dashboards, applications) without duplicate headers.
class MainShellScreen extends StatefulWidget {
  const MainShellScreen({
    super.key,
    this.initialAuthenticated,
  });

  final bool? initialAuthenticated;

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _activeTab = 0; // 0: Home, 1: Jobs, 2: Candidate, 3: Employer
  bool _isWebViewActive = false;
  bool _hasLoadedWebView = false;
  double _loadingProgress = 0.0;
  bool _isLoading = false;
  bool _canGoBack = false;
  String _currentUrl = AppConfig.initialUrl;

  late bool _isAuthenticated;
  bool _isGuestMode = false;
  String? _userRole;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<PhaseTwoWebViewScreenState> _webViewKey =
      GlobalKey<PhaseTwoWebViewScreenState>();

  @override
  void initState() {
    super.initState();
    _isAuthenticated = widget.initialAuthenticated ??
        AuthSessionService.instance.isAuthenticated;
    _userRole = AuthSessionService.instance.userRole;
  }

  void _onTabSelected(int index) {
    setState(() {
      _activeTab = index;
      _isWebViewActive = false; // Always return to native UI on bottom tab selection
      _isGuestMode = true; // Tab selection implies exploring the native app
    });
  }

  void _openUrlInWebView(String url) {
    final Uri? uri = Uri.tryParse(url);
    if (uri != null) {
      if (UrlHandlerService.isCandidateLoginUrl(uri)) {
        _closeWebView();
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => CandidateLoginScreen(
              onLoginSuccess: _onNativeAuthSuccess,
              onAuthSuccess: _onNativeAuthSuccess,
            ),
          ),
        );
        return;
      }
      if (UrlHandlerService.isEmployerLoginUrl(uri)) {
        _closeWebView();
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => EmployerLoginScreen(
              onLoginSuccess: _onNativeAuthSuccess,
              onAuthSuccess: _onNativeAuthSuccess,
            ),
          ),
        );
        return;
      }
      if (UrlHandlerService.isCandidateRegisterUrl(uri)) {
        _closeWebView();
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => CandidateSignupScreen(
              onSignupSuccess: _onNativeAuthSuccess,
              onAuthSuccess: _onNativeAuthSuccess,
            ),
          ),
        );
        return;
      }
      if (UrlHandlerService.isEmployerRegisterUrl(uri)) {
        _closeWebView();
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => EmployerSignupScreen(
              onSignupSuccess: _onNativeAuthSuccess,
              onAuthSuccess: _onNativeAuthSuccess,
            ),
          ),
        );
        return;
      }
      if (UrlHandlerService.isForgotPasswordUrl(uri)) {
        _closeWebView();
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const ForgotPasswordScreen(),
          ),
        );
        return;
      }
      if (UrlHandlerService.isHomePageUrl(uri)) {
        _onTabSelected(0);
        return;
      }
    }

    setState(() {
      _hasLoadedWebView = true;
      _isWebViewActive = true;
      _currentUrl = url;
    });
    // Ensure that if the controller was already ready, it navigates to the requested url.
    // If not yet mounted, passing initialUrl: _currentUrl ensures it initializes with this URL.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _webViewKey.currentState?.loadPage(url);
      }
    });
  }

  void _closeWebView() {
    setState(() {
      _isWebViewActive = false;
    });
  }

  String _getFormattedDomain() {
    try {
      final Uri uri = Uri.parse(_currentUrl);
      final String host = uri.host.replaceFirst('www.', '');
      if (uri.path.isNotEmpty && uri.path != '/') {
        final String pathSegment =
            uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
        if (pathSegment.isNotEmpty) {
          final String title = pathSegment
              .replaceAll('_', ' ')
              .replaceAll('-', ' ');
          if (title.isNotEmpty) {
            final String formattedTitle =
                title[0].toUpperCase() + title.substring(1);
            return '$host · $formattedTitle';
          }
        }
      }
      return host.isNotEmpty ? host : 'phasetwo.ca';
    } catch (_) {
      return 'phasetwo.ca';
    }
  }

  Future<bool> _showExitDialog() async {
    if (!mounted) return false;
    final bool? shouldExit = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: <Widget>[
              Icon(Icons.exit_to_app_rounded, color: AppConfig.primaryColor),
              SizedBox(width: 8),
              Text('Exit PhaseTwo?'),
            ],
          ),
          content: const Text(
            'Are you sure you want to exit the application?',
            style: TextStyle(fontSize: 14.5, color: AppConfig.textMuted),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConfig.primaryNavy,
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

    return shouldExit ?? false;
  }

  Future<void> _handleLogout() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: <Widget>[
              Icon(Icons.logout_rounded, color: AppConfig.primaryNavy),
              SizedBox(width: 8),
              Text('Sign Out'),
            ],
          ),
          content: const Text(
            'Are you sure you want to sign out of PhaseTwo?',
            style: TextStyle(fontSize: 14.5, color: AppConfig.textMuted),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConfig.primaryNavy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );

    if (confirm == true && mounted) {
      await AuthApiService.instance.logout();
      await AuthSessionService.instance.clearSession();
      if (_hasLoadedWebView) {
        _webViewKey.currentState?.loadPage(AppConfig.candidateLogoutUrl);
      }
      setState(() {
        _isAuthenticated = false;
        _isGuestMode = false;
        _userRole = null;
        _isWebViewActive = false;
        _activeTab = 0;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have signed out successfully.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _onNativeAuthSuccess() {
    setState(() {
      _isAuthenticated = AuthSessionService.instance.isAuthenticated;
      _userRole = AuthSessionService.instance.userRole;
      _isGuestMode = true;
      _isWebViewActive = false;
      _activeTab = (_userRole == 'employer' || _userRole == 'recruiter') ? 3 : 2;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _userRole == 'employer' || _userRole == 'recruiter'
                ? 'Welcome back! Employer session verified.'
                : 'Welcome back! Candidate session verified.',
          ),
          backgroundColor: AppConfig.primaryNavy,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<bool> _handleWillPop() async {
    // 1. Close drawer if open
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
      return false;
    }

    // 2. Delegate to WebView history if active
    if (_isWebViewActive) {
      final bool handledByWebView =
          await _webViewKey.currentState?.handleBack() ?? false;
      if (handledByWebView) {
        return false;
      }
      // If at root of WebView history, close webview and return to native UI
      _closeWebView();
      return false;
    }

    // 3. If on non-home native tab, return to Home tab
    if (_activeTab != 0) {
      _onTabSelected(0);
      return false;
    }

    // 4. If on Home tab, show exit confirmation dialog
    return await _showExitDialog();
  }

  void _showSearchModal() {
    final TextEditingController searchCtrl = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
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
                'Search Jobs & Flexible Gigs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppConfig.primaryNavy,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Search roles, fractional leadership, or Canadian cities',
                style: TextStyle(fontSize: 12.5, color: AppConfig.textMuted),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: searchCtrl,
                autofocus: true,
                textInputAction: TextInputAction.search,
                onSubmitted: (String query) {
                  Navigator.pop(context);
                  final String q = query.trim();
                  if (q.isNotEmpty) {
                    _openUrlInWebView('${AppConfig.jobsUrl}?search=$q');
                  } else {
                    _onTabSelected(1);
                  }
                },
                decoration: InputDecoration(
                  hintText: 'e.g. Director, Operations, Remote, Toronto...',
                  prefixIcon: const Icon(Icons.search_rounded, color: AppConfig.primaryColor),
                  filled: true,
                  fillColor: AppConfig.backgroundLight,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppConfig.cardBorder),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  final String q = searchCtrl.text.trim();
                  Navigator.pop(context);
                  if (q.isNotEmpty) {
                    _openUrlInWebView('${AppConfig.jobsUrl}?search=$q');
                  } else {
                    _onTabSelected(1);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConfig.primaryColor,
                  foregroundColor: AppConfig.primaryNavy,
                  minimumSize: const Size(double.infinity, 46),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.search_rounded, size: 18),
                label: const Text(
                  'Search Live Jobs',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    if (_isWebViewActive) {
      // Clean In-App Web Presentation Bar (TASK 5 FIX: Eliminates Duplicate Header)
      // The website already includes its own full header. We avoid stacking the thick
      // native branding header above it, using a sleek 44px in-app navigation bar instead.
      return PreferredSize(
        preferredSize: const Size.fromHeight(48.0),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: AppConfig.cardBorder, width: 0.8),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        _canGoBack
                            ? Icons.arrow_back_ios_new_rounded
                            : Icons.arrow_back_rounded,
                        size: 18,
                        color: AppConfig.primaryNavy,
                      ),
                      onPressed: () async {
                        final bool handled =
                            await _webViewKey.currentState?.handleBack() ?? false;
                        if (!handled) {
                          _closeWebView();
                        }
                      },
                      tooltip: _canGoBack ? 'Previous Page' : 'Return to App',
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(Icons.lock_rounded, size: 13, color: AppConfig.accentGreenDark),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              _getFormattedDomain(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: AppConfig.textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20, color: AppConfig.textMuted),
                      onPressed: _closeWebView,
                      tooltip: 'Return to App',
                    ),
                  ],
                ),
              ),
              WebProgressBar(
                progress: _loadingProgress,
                isVisible: _isLoading,
              ),
            ],
          ),
        ),
      );
    }

    // Native Option B App Header (TASK 3: Clean Header, No Globe, No Refresh Icon)
    return CustomAppHeader(
      onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      onOpenSearch: _showSearchModal,
    );
  }

  @override
  Widget build(BuildContext context) {
    // If not authenticated and not explicitly browsing as guest, and webview is not active,
    // display the native PhaseTwo Authentication Welcome Screen
    if (!_isAuthenticated && !_isGuestMode && !_isWebViewActive) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, dynamic result) async {
          if (didPop) return;
          final bool shouldExit = await _showExitDialog();
          if (shouldExit && mounted) {
            SystemNavigator.pop();
          }
        },
        child: AuthWelcomeScreen(
          onOpenAuthUrl: _openUrlInWebView,
          onAuthSuccess: _onNativeAuthSuccess,
          onCandidateLogin: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => CandidateLoginScreen(
                  onLoginSuccess: _onNativeAuthSuccess,
                  onAuthSuccess: _onNativeAuthSuccess,
                ),
              ),
            );
          },
          onCandidateSignup: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => CandidateSignupScreen(
                  onSignupSuccess: _onNativeAuthSuccess,
                  onAuthSuccess: _onNativeAuthSuccess,
                ),
              ),
            );
          },
          onEmployerLogin: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => EmployerLoginScreen(
                  onLoginSuccess: _onNativeAuthSuccess,
                  onAuthSuccess: _onNativeAuthSuccess,
                ),
              ),
            );
          },
          onEmployerSignup: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => EmployerSignupScreen(
                  onSignupSuccess: _onNativeAuthSuccess,
                  onAuthSuccess: _onNativeAuthSuccess,
                ),
              ),
            );
          },
          onExploreAsGuest: () {
            setState(() {
              _isGuestMode = true;
            });
          },
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        final bool shouldExit = await _handleWillPop();
        if (shouldExit && mounted) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        drawer: AppDrawer(
          onNavigateToTab: _onTabSelected,
          onOpenUrl: _openUrlInWebView,
          isAuthenticated: _isAuthenticated,
          userRole: _userRole,
          onLogout: _handleLogout,
          onAuthSuccess: _onNativeAuthSuccess,
          onOpenWelcome: () {
            setState(() {
              _isGuestMode = false;
              _isWebViewActive = false;
            });
          },
        ),
        body: Stack(
          children: <Widget>[
            // Native Option B Screens (Home, Jobs, Candidates, Employers)
            IndexedStack(
              index: _activeTab,
              children: <Widget>[
                // Tab 0: Approved Native Option B Modern Dynamic Home Dashboard
                HomeScreen(
                  onNavigateToTab: _onTabSelected,
                  onOpenUrl: _openUrlInWebView,
                ),
                // Tab 1: Approved Native Option B Modern Dynamic Job Search UI
                JobsScreen(
                  onOpenUrl: _openUrlInWebView,
                ),
                // Tab 2: Approved Native Option B Candidate Portal Screen
                CandidateSectionScreen(
                  onOpenUrl: _openUrlInWebView,
                  onAuthSuccess: _onNativeAuthSuccess,
                ),
                // Tab 3: Approved Native Option B Employer Portal Screen
                EmployerSectionScreen(
                  onOpenUrl: _openUrlInWebView,
                  onAuthSuccess: _onNativeAuthSuccess,
                ),
              ],
            ),
            // Integrated Persistent In-App WebView (Lazy-loaded upon first web action)
            if (_hasLoadedWebView)
              Offstage(
                offstage: !_isWebViewActive,
                child: PhaseTwoWebViewScreen(
                  key: _webViewKey,
                  initialUrl: _currentUrl,
                  showAppBar: false,
                  onClose: _closeWebView,
                  onReturnHome: () => _onTabSelected(0),
                  onProgressChanged: (double progress) {
                    if (!mounted) return;
                    setState(() {
                      _loadingProgress = progress;
                    });
                  },
                  onLoadingChanged: (bool loading) {
                    if (!mounted) return;
                    setState(() {
                      _isLoading = loading;
                    });
                  },
                  onAuthSignalDetected: (String jsonSignal, String url) async {
                    if (!mounted) return;
                    final bool signalVerified = await AuthSessionService.instance
                        .evaluateWebsiteSignal(jsonSignal, url);
                    if (!mounted || !context.mounted) return;

                    if (signalVerified) {
                      setState(() {
                        _isAuthenticated = true;
                        _userRole = AuthSessionService.instance.userRole;
                        _isWebViewActive = false;
                        _activeTab = 0;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _userRole == 'employer'
                                ? 'Welcome back! Employer session verified.'
                                : 'Welcome back! Candidate session verified.',
                          ),
                          backgroundColor: AppConfig.primaryNavy,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  onUrlChanged: (String url) async {
                    if (!mounted) return;
                    setState(() {
                      _currentUrl = url;
                    });

                    // Evaluate URL for reliable website authentication or logout signal
                    final bool signalVerified =
                        await AuthSessionService.instance.evaluateWebsiteUrl(url);
                    if (!mounted || !context.mounted) return;

                    if (signalVerified) {
                      setState(() {
                        _isAuthenticated = true;
                        _userRole = AuthSessionService.instance.userRole;
                        _isWebViewActive = false;
                        _activeTab = 0;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _userRole == 'candidate'
                                ? 'Welcome back! Candidate session verified.'
                                : 'Welcome back! Employer session verified.',
                          ),
                          backgroundColor: AppConfig.primaryNavy,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    } else if (url.toLowerCase().contains('/logout') ||
                        url.toLowerCase().contains('logged_out=1')) {
                      setState(() {
                        _isAuthenticated = false;
                        _userRole = null;
                        _isGuestMode = false;
                        _isWebViewActive = false;
                        _activeTab = 0;
                      });
                    }
                  },
                  onCanGoBackChanged: (bool canBack) {
                    if (!mounted) return;
                    setState(() {
                      _canGoBack = canBack;
                    });
                  },
                ),
              ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _isWebViewActive ? _activeTab : _activeTab,
          onTap: _onTabSelected,
        ),
      ),
    );
  }
}
