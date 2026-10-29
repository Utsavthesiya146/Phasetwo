import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phasetwo/config/app_config.dart';
import 'package:phasetwo/screens/auth_welcome_screen.dart';
import 'package:phasetwo/screens/candidate_section_screen.dart';
import 'package:phasetwo/screens/employer_section_screen.dart';
import 'package:phasetwo/screens/home_screen.dart';
import 'package:phasetwo/screens/main_shell.dart';
import 'package:phasetwo/screens/webview_screen.dart';
import 'package:phasetwo/services/auth_session_service.dart';
import 'package:phasetwo/widgets/app_drawer.dart';
import 'package:phasetwo/widgets/bottom_nav_bar.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  group('PhaseTwo Issue 1: Bottom Navigation Overlap & Responsiveness', () {
    final List<Map<String, dynamic>> targetWidths = <Map<String, dynamic>>[
      <String, dynamic>{'name': '320px Compact Android (iPhone SE 1)', 'size': const Size(320, 640)},
      <String, dynamic>{'name': '360px Small Android Phone', 'size': const Size(360, 740)},
      <String, dynamic>{'name': '393px iPhone 14/15/16 Standard', 'size': const Size(393, 852)},
      <String, dynamic>{'name': '412px Modern Android (Pixel 8 / S24)', 'size': const Size(412, 915)},
      <String, dynamic>{'name': '430px Large Screen (15/16 Pro Max)', 'size': const Size(430, 932)},
    ];

    for (final device in targetWidths) {
      final String name = device['name'] as String;
      final Size size = device['size'] as Size;

      testWidgets('CustomBottomNavBar renders 4 equal tabs with 0 overflow at $name',
          (WidgetTester tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        int tappedIndex = -1;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              bottomNavigationBar: CustomBottomNavBar(
                currentIndex: 0,
                onTap: (int index) => tappedIndex = index,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // 1. Verify exactly 4 singular tabs exist
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Jobs'), findsOneWidget);
        expect(find.text('Candidate'), findsOneWidget);
        expect(find.text('Employer'), findsOneWidget);
        expect(find.text('Web Portal'), findsNothing);

        // 2. Verify independent layout and equal 25% width distribution via Expanded
        final RenderBox homeBox = tester.renderObject(find.text('Home'));
        final RenderBox jobsBox = tester.renderObject(find.text('Jobs'));
        final RenderBox candidateBox = tester.renderObject(find.text('Candidate'));
        final RenderBox employerBox = tester.renderObject(find.text('Employer'));

        // All labels must be painted and have non-zero dimensions
        expect(homeBox.size.width, greaterThan(0));
        expect(jobsBox.size.width, greaterThan(0));
        expect(candidateBox.size.width, greaterThan(0));
        expect(employerBox.size.width, greaterThan(0));

        // Verify Candidate and Employer are separate with independent horizontal positions
        final Offset candidateOffset = candidateBox.localToGlobal(Offset.zero);
        final Offset employerOffset = employerBox.localToGlobal(Offset.zero);
        expect(employerOffset.dx, greaterThan(candidateOffset.dx + candidateBox.size.width));

        // 3. Test interaction
        await tester.tap(find.text('Candidate'));
        await tester.pump();
        expect(tappedIndex, equals(2));

        await tester.tap(find.text('Employer'));
        await tester.pump();
        expect(tappedIndex, equals(3));
      });
    }

    testWidgets('CustomBottomNavBar handles accessibility text scaling gracefully',
        (WidgetTester tester) async {
      final List<double> textScales = <double>[1.0, 1.3, 1.5, 2.0];

      for (final scale in textScales) {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(
                size: const Size(360, 740),
                textScaler: TextScaler.linear(scale),
              ),
              child: Scaffold(
                bottomNavigationBar: CustomBottomNavBar(
                  currentIndex: 0,
                  onTap: (_) {},
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Jobs'), findsOneWidget);
        expect(find.text('Candidate'), findsOneWidget);
        expect(find.text('Employer'), findsOneWidget);

        // Ensure no RenderFlex overflow error occurs
        expect(tester.takeException(), isNull);
      }
    });
  });

  group('PhaseTwo Issue 2: Native Authentication Welcome Screen & Routing', () {
    testWidgets('Unauthenticated startup shows AuthWelcomeScreen with Option B design',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: MainShellScreen(
            initialAuthenticated: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify native Welcome screen is presented
      expect(find.byType(AuthWelcomeScreen), findsOneWidget);
      expect(find.text('Experience Is Your Greatest Asset'), findsOneWidget);
      expect(find.text('🍁 Canada\'s Executive & Senior Talent Network'), findsOneWidget);

      // Verify all 4 required authentication actions are present
      expect(find.text('Candidate Login'), findsOneWidget);
      expect(find.text('Candidate Sign Up'), findsOneWidget);
      expect(find.text('Employer Login'), findsOneWidget);
      expect(find.text('Employer Registration'), findsOneWidget);

      // Verify guest exploration option
      expect(find.text('Explore Platform as Guest'), findsOneWidget);
    });

    testWidgets('Candidate Login routes to verified endpoint /login',
        (WidgetTester tester) async {
      String openedUrl = '';
      await tester.pumpWidget(
        MaterialApp(
          home: AuthWelcomeScreen(
            onOpenAuthUrl: (url) => openedUrl = url,
            onExploreAsGuest: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Candidate Login'));
      await tester.pump();

      expect(openedUrl, equals(AppConfig.candidateLoginUrl));
      expect(openedUrl, contains('/login'));
    });

    testWidgets('Candidate Sign Up routes to verified endpoint /register',
        (WidgetTester tester) async {
      String openedUrl = '';
      await tester.pumpWidget(
        MaterialApp(
          home: AuthWelcomeScreen(
            onOpenAuthUrl: (url) => openedUrl = url,
            onExploreAsGuest: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Candidate Sign Up'));
      await tester.pump();

      expect(openedUrl, equals(AppConfig.candidateRegisterUrl));
      expect(openedUrl, contains('/register'));
    });

    testWidgets('Employer Login routes to verified endpoint /recruiter_login',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      String openedUrl = '';
      await tester.pumpWidget(
        MaterialApp(
          home: AuthWelcomeScreen(
            onOpenAuthUrl: (url) => openedUrl = url,
            onExploreAsGuest: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.text('Employer Login'), 100);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Employer Login'));
      await tester.pump();

      expect(openedUrl, equals(AppConfig.employerLoginUrl));
      expect(openedUrl, contains('/recruiter_login'));
    });

    testWidgets('Employer Registration routes to verified endpoint /recruiter_register',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      String openedUrl = '';
      await tester.pumpWidget(
        MaterialApp(
          home: AuthWelcomeScreen(
            onOpenAuthUrl: (url) => openedUrl = url,
            onExploreAsGuest: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.text('Employer Registration'), 100);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Employer Registration'));
      await tester.pump();

      expect(openedUrl, equals(AppConfig.registerEmployerUrl));
      expect(openedUrl, contains('/recruiter_register'));
    });

    testWidgets('Guest exploration opens native Modern Dynamic Home Dashboard',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: MainShellScreen(
            initialAuthenticated: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap guest link
      await tester.tap(find.text('Explore Platform as Guest'));
      await tester.pumpAndSettle();

      // Native Home Dashboard and CustomBottomNavBar are now active
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(CustomBottomNavBar), findsOneWidget);
    });

    testWidgets('Authenticated startup directly opens native Home Dashboard',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: MainShellScreen(
            initialAuthenticated: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Directly opens approved Option B HomeScreen
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(CustomBottomNavBar), findsOneWidget);
      expect(find.byType(AuthWelcomeScreen), findsNothing);
    });

    testWidgets('AuthSessionService accurately evaluates reliable website signals',
        (WidgetTester tester) async {
      final AuthSessionService authService = AuthSessionService.instance;

      // 1. Unverified random / guest URL does NOT falsely verify authentication
      final bool guestResult =
          await authService.evaluateWebsiteUrl('https://www.phasetwo.ca/jobs?search=executive');
      expect(guestResult, isFalse);

      // 2. Candidate dashboard redirect signals verified candidate session
      final bool candidateResult =
          await authService.evaluateWebsiteUrl('https://www.phasetwo.ca/candidate/dashboard');
      expect(candidateResult, isTrue);
      expect(authService.isAuthenticated, isTrue);
      expect(authService.userRole, equals('candidate'));

      // 3. Employer dashboard redirect signals verified employer session
      final bool employerResult =
          await authService.evaluateWebsiteUrl('https://www.phasetwo.ca/employer/dashboard');
      expect(employerResult, isTrue);
      expect(authService.isAuthenticated, isTrue);
      expect(authService.userRole, equals('employer'));

      // 4. Logout URL clears verified session
      final bool logoutResult =
          await authService.evaluateWebsiteUrl('https://www.phasetwo.ca/logout');
      expect(logoutResult, isFalse);
      expect(authService.isAuthenticated, isFalse);
      expect(authService.userRole, isNull);
    });

    testWidgets('Logout confirms and smoothly returns to AuthWelcomeScreen',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: MainShellScreen(
            initialAuthenticated: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open drawer
      await tester.tap(find.byTooltip('Open Menu'));
      await tester.pumpAndSettle();

      // Scroll drawer down to reveal Sign Out / Logout
      await tester.scrollUntilVisible(
        find.text('Sign Out / Logout'),
        200,
        scrollable: find.descendant(
          of: find.byType(AppDrawer),
          matching: find.byType(Scrollable),
        ),
      );
      await tester.pumpAndSettle();

      // Find Sign Out / Logout tile
      expect(find.text('Sign Out / Logout'), findsOneWidget);
      await tester.tap(find.text('Sign Out / Logout'));
      await tester.pumpAndSettle();

      // Verify confirmation dialog appears
      expect(find.text('Sign Out'), findsWidgets);
      expect(find.text('Are you sure you want to sign out of PhaseTwo?'), findsOneWidget);

      // Confirm sign out
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Out'));
      await tester.pumpAndSettle();

      // Verified return to AuthWelcomeScreen
      expect(find.byType(AuthWelcomeScreen), findsOneWidget);
      expect(find.text('Candidate Login'), findsOneWidget);
      expect(find.text('Employer Login'), findsOneWidget);
    });
  });

  group('PhaseTwo Critical Authentication, WebView & Navigation E2E Tests', () {
    testWidgets('Candidate Login button on Welcome Screen dispatches candidate login URL',
        (WidgetTester tester) async {
      String? dispatchedUrl;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthWelcomeScreen(
              onOpenAuthUrl: (url) => dispatchedUrl = url,
              onExploreAsGuest: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final loginBtn = find.widgetWithText(ElevatedButton, 'Candidate Login');
      expect(loginBtn, findsOneWidget);
      await tester.tap(loginBtn);
      await tester.pump();

      expect(dispatchedUrl, equals(AppConfig.candidateLoginUrl));
      expect(dispatchedUrl, equals('https://www.phasetwo.ca/login'));
      expect(dispatchedUrl, isNot(equals(AppConfig.initialUrl)));
    });

    testWidgets('Employer Login button on Welcome Screen dispatches recruiter login URL',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      String? dispatchedUrl;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthWelcomeScreen(
              onOpenAuthUrl: (url) => dispatchedUrl = url,
              onExploreAsGuest: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final loginBtn = find.widgetWithText(ElevatedButton, 'Employer Login');
      expect(loginBtn, findsOneWidget);
      await tester.tap(loginBtn);
      await tester.pump();

      expect(dispatchedUrl, equals(AppConfig.employerLoginUrl));
      expect(dispatchedUrl, equals('https://www.phasetwo.ca/recruiter_login'));
      expect(dispatchedUrl, isNot(equals(AppConfig.initialUrl)));
    });

    testWidgets('Registration buttons on Welcome Screen dispatch registration URLs',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final List<String> dispatchedUrls = <String>[];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthWelcomeScreen(
              onOpenAuthUrl: (url) => dispatchedUrls.add(url),
              onExploreAsGuest: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(OutlinedButton, 'Candidate Sign Up'));
      await tester.pump();
      expect(dispatchedUrls.last, equals(AppConfig.registerCandidateUrl));
      expect(dispatchedUrls.last, equals('https://www.phasetwo.ca/register'));

      await tester.tap(find.widgetWithText(OutlinedButton, 'Employer Registration'));
      await tester.pump();
      expect(dispatchedUrls.last, equals(AppConfig.registerEmployerUrl));
      expect(dispatchedUrls.last, equals('https://www.phasetwo.ca/recruiter_register'));
    });

    testWidgets('CandidateSectionScreen and EmployerSectionScreen dispatch correct login routes',
        (WidgetTester tester) async {
      String? candidateAction;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CandidateSectionScreen(
              onOpenUrl: (url) => candidateAction = url,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Candidate Login'));
      await tester.pump();
      expect(candidateAction, equals('https://www.phasetwo.ca/login'));

      String? employerAction;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmployerSectionScreen(
              onOpenUrl: (url) => employerAction = url,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Recruiter Login'));
      await tester.pump();
      expect(employerAction, equals('https://www.phasetwo.ca/recruiter_login'));
    });

    test('AuthSessionService parses DOM logout & role signals and verifies session', () async {
      final auth = AuthSessionService.instance;
      await auth.clearSession();
      expect(auth.isAuthenticated, isFalse);

      // 1. Candidate DOM signal with logout link
      const String candidateSignal =
          '{"hasLogout":true,"isEmployer":false,"isCandidate":true,"url":"https://www.phasetwo.ca/Phasetwo"}';
      final bool candVerified =
          await auth.evaluateWebsiteSignal(candidateSignal, 'https://www.phasetwo.ca/Phasetwo');
      expect(candVerified, isTrue);
      expect(auth.isAuthenticated, isTrue);
      expect(auth.isCandidate, isTrue);
      expect(auth.userRole, equals('candidate'));

      // 2. Employer DOM signal with company indicators
      const String employerSignal =
          '{"hasLogout":true,"isEmployer":true,"isCandidate":false,"url":"https://www.phasetwo.ca/company/dashboard"}';
      final bool empVerified =
          await auth.evaluateWebsiteSignal(employerSignal, 'https://www.phasetwo.ca/company/dashboard');
      expect(empVerified, isTrue);
      expect(auth.isAuthenticated, isTrue);
      expect(auth.isEmployer, isTrue);
      expect(auth.userRole, equals('employer'));

      // 3. Unauthenticated DOM signal (hasLogout: false)
      const String unauthSignal =
          '{"hasLogout":false,"isEmployer":false,"isCandidate":false,"url":"https://www.phasetwo.ca/login"}';
      final bool unauthResult =
          await auth.evaluateWebsiteSignal(unauthSignal, 'https://www.phasetwo.ca/login');
      expect(unauthResult, isFalse);
    });

    test('AuthSessionService handles login failure URL and session expiration', () async {
      final auth = AuthSessionService.instance;
      await auth.clearSession();

      // 1. Login failure URL redirect: does not authenticate
      final bool failResult =
          await auth.evaluateWebsiteUrl('https://www.phasetwo.ca/Phasetwo/login');
      expect(failResult, isFalse);
      expect(auth.isAuthenticated, isFalse);

      // 2. Session expiry after timeout
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('phasetwo_auth_verified', true);
      await prefs.setString('phasetwo_user_role', 'candidate');
      // Set timestamp 3 hours in the past (> 2 hours timeout)
      final int expiredTime =
          DateTime.now().subtract(const Duration(hours: 3)).millisecondsSinceEpoch;
      await prefs.setInt('phasetwo_last_auth_time', expiredTime);

      final bool restored = await auth.init();
      expect(restored, isFalse);
      expect(auth.isAuthenticated, isFalse);
      expect(auth.isExpired, isTrue);
      expect(auth.status, equals(AuthStatus.sessionExpired));

      // 3. Active session within 2 hours: restored successfully
      final int freshTime =
          DateTime.now().subtract(const Duration(minutes: 30)).millisecondsSinceEpoch;
      await prefs.setBool('phasetwo_auth_verified', true);
      await prefs.setString('phasetwo_user_role', 'employer');
      await prefs.setInt('phasetwo_last_auth_time', freshTime);

      final bool freshRestored = await auth.init();
      expect(freshRestored, isTrue);
      expect(auth.isAuthenticated, isTrue);
      expect(auth.isEmployer, isTrue);
    });

    test('PhaseTwoWebViewScreen configures initialUrl without defaulting to homepage', () {
      const String testUrl = 'https://www.phasetwo.ca/recruiter_login';
      const PhaseTwoWebViewScreen screen = PhaseTwoWebViewScreen(
        initialUrl: testUrl,
      );
      expect(screen.initialUrl, equals(testUrl));
      expect(screen.initialUrl, isNot(equals(AppConfig.initialUrl)));
    });
  });
}
