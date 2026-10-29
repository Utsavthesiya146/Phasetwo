import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phasetwo/screens/auth/candidate_login_screen.dart';
import 'package:phasetwo/screens/auth/candidate_signup_screen.dart';
import 'package:phasetwo/screens/auth/employer_login_screen.dart';
import 'package:phasetwo/screens/auth/employer_signup_screen.dart';
import 'package:phasetwo/screens/auth/forgot_password_screen.dart';
import 'package:phasetwo/services/auth_api_service.dart';
import 'package:phasetwo/services/auth_session_service.dart';
import 'package:phasetwo/widgets/auth/auth_components.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    AuthApiService.instance.mockHandler = null;
  });

  tearDown(() {
    AuthApiService.instance.mockHandler = null;
  });

  group('PhaseTwo Native Auth UI — CandidateLoginScreen', () {
    testWidgets('Renders all native candidate login elements in Option B design',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: CandidateLoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Header and Canadian branding
      expect(find.text('Candidate Sign In'), findsOneWidget);
      expect(find.text('🍁 Experienced Talent Network'), findsOneWidget);
      expect(
        find.text('Access executive, fractional, and senior roles across Canada.'),
        findsOneWidget,
      );

      // Input labels and icons
      expect(find.text('Email or Phone Number'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Sign In as Candidate'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text('Join PhaseTwo'), findsOneWidget);
      expect(find.text('Looking to Hire? Employer Login'), findsOneWidget);
    });

    testWidgets('Validates empty credentials',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: CandidateLoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap submit with empty fields
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In as Candidate'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your registered email or phone.'), findsOneWidget);
      expect(find.text('Please enter your password.'), findsOneWidget);
    });

    testWidgets('Toggles password visibility securely',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: CandidateLoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Initially obscure password is true -> visibility_off_outlined
      final visibilityToggle = find.byIcon(Icons.visibility_off_outlined);
      expect(visibilityToggle, findsOneWidget);

      await tester.tap(visibilityToggle);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('Displays server-side error feedback banner upon failed authentication',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      AuthApiService.instance.mockHandler = (String url, Map<String, String> fields) async {
        return const AuthResult.failure('Invalid email or password. Please try again.');
      };

      await tester.pumpWidget(
        const MaterialApp(
          home: CandidateLoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'e.g. yourname@domain.ca'),
        'candidate@phasetwo.ca',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, '••••••••'),
        'WrongPassword123!',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In as Candidate'));
      await tester.pumpAndSettle();

      expect(find.byType(AuthFeedbackBanner), findsOneWidget);
      expect(find.text('Invalid email or password. Please try again.'), findsOneWidget);
    });

    testWidgets('Invokes onLoginSuccess and updates session on valid credentials',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      bool loginSuccessFired = false;
      AuthApiService.instance.mockHandler = (String url, Map<String, String> fields) async {
        await AuthSessionService.instance.setVerifiedSession(
          authenticated: true,
          role: 'candidate',
          email: fields['email'],
          sessionToken: 'candidate_token_abc123',
        );
        return const AuthResult.success(
          userRole: 'candidate',
          sessionToken: 'candidate_token_abc123',
        );
      };

      await tester.pumpWidget(
        MaterialApp(
          home: CandidateLoginScreen(
            onLoginSuccess: () => loginSuccessFired = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'e.g. yourname@domain.ca'),
        'valid.candidate@phasetwo.ca',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, '••••••••'),
        'CorrectPass123!',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In as Candidate'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 4));

      expect(loginSuccessFired, isTrue);
      expect(AuthSessionService.instance.isAuthenticated, isTrue);
      expect(AuthSessionService.instance.userRole, equals('candidate'));
    });
  });

  group('PhaseTwo Native Auth UI — EmployerLoginScreen', () {
    testWidgets('Renders all native employer login elements in Option B design',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: EmployerLoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Recruiter Sign In'), findsOneWidget);
      expect(find.text('🍁 Employer & Recruiter Console'), findsOneWidget);
      expect(find.text('Company Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Sign In to Console'), findsOneWidget);
      expect(find.text('Register Employer'), findsOneWidget);
      expect(find.text('Looking to Hire? Employer Login'), findsNothing);
    });

    testWidgets('Validates required company email and password',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: EmployerLoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In to Console'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your registered corporate email.'), findsOneWidget);
      expect(find.text('Please enter your password.'), findsOneWidget);
    });

    testWidgets('Invokes onLoginSuccess and updates employer session upon valid login',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      bool employerSuccessFired = false;
      AuthApiService.instance.mockHandler = (String url, Map<String, String> fields) async {
        await AuthSessionService.instance.setVerifiedSession(
          authenticated: true,
          role: 'employer',
          email: fields['company_email'],
          sessionToken: 'employer_token_xyz789',
        );
        return const AuthResult.success(
          userRole: 'employer',
          sessionToken: 'employer_token_xyz789',
        );
      };

      await tester.pumpWidget(
        MaterialApp(
          home: EmployerLoginScreen(
            onLoginSuccess: () => employerSuccessFired = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'e.g. recruiter@company.ca'),
        'recruiter@acme.ca',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, '••••••••'),
        'AcmePass123!',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In to Console'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 4));

      expect(employerSuccessFired, isTrue);
      expect(AuthSessionService.instance.isAuthenticated, isTrue);
      expect(AuthSessionService.instance.userRole, equals('employer'));
    });
  });

  group('PhaseTwo Native Auth UI — CandidateSignupScreen', () {
    testWidgets('Renders all registration fields and validates password match',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: CandidateSignupScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Verified Canadian candidate signup banner
      expect(find.text('Join PhaseTwo'), findsOneWidget);
      expect(find.text('🍁 Free Candidate Registration'), findsOneWidget);
      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Professional Stream / Domain'), findsOneWidget);
      expect(find.text('Preferred Work Location'), findsOneWidget);
      expect(find.text('Date of Birth (YYYY-MM-DD)'), findsOneWidget);
      expect(find.text('Create Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);

      // Validate required fields
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Candidate Account'));
      await tester.pumpAndSettle();

      expect(find.text('Required'), findsAtLeast(2)); // First name and last name
      expect(find.text('Please enter your email.'), findsOneWidget);

      // Enter mismatched passwords
      await tester.enterText(find.widgetWithText(TextFormField, 'e.g. Jean'), 'Jane');
      await tester.enterText(find.widgetWithText(TextFormField, 'e.g. Dupont'), 'Doe');
      await tester.enterText(
        find.widgetWithText(TextFormField, 'e.g. jean.dupont@domain.ca'),
        'jane@doe.ca',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'e.g. +1 (416) 555-0199'),
        '4165550199',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'e.g. Toronto, ON / Remote Canada'),
        'Toronto, ON',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'YYYY-MM-DD'),
        '1980-05-15',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Min 6 characters'),
        'Secret123!',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Re-enter your password'),
        'DifferentPass!',
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Candidate Account'));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match.'), findsOneWidget);
    });

    testWidgets('Submits candidate registration successfully',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      AuthApiService.instance.mockHandler = (String url, Map<String, String> fields) async {
        return const AuthResult.success(
          successMessage: 'Account created! Please sign in with your credentials.',
        );
      };

      await tester.pumpWidget(
        const MaterialApp(
          home: CandidateSignupScreen(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextFormField, 'e.g. Jean'), 'Jane');
      await tester.enterText(find.widgetWithText(TextFormField, 'e.g. Dupont'), 'Doe');
      await tester.enterText(
        find.widgetWithText(TextFormField, 'e.g. jean.dupont@domain.ca'),
        'jane.doe@example.ca',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'e.g. +1 (416) 555-0199'),
        '4165550199',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'e.g. Toronto, ON / Remote Canada'),
        'Toronto, ON',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'YYYY-MM-DD'),
        '1980-05-15',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Min 6 characters'),
        'Secret123!',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Re-enter your password'),
        'Secret123!',
      );

      // Check Terms checkbox
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Candidate Account'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Account created! Please sign in with your credentials.'), findsAtLeast(1));
      await tester.pump(const Duration(seconds: 4));
    });
  });

  group('PhaseTwo Native Auth UI — EmployerSignupScreen', () {
    testWidgets('Renders all employer registration fields including Starter plan info',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: EmployerSignupScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Register Organization'), findsAtLeast(1));
      expect(find.text('🍁 Employer & Recruiter Registration'), findsOneWidget);
      expect(find.text('Contact Person Name'), findsOneWidget);
      expect(find.text('Company / Organization Name'), findsOneWidget);
      expect(find.text('Company Phone Number'), findsOneWidget);
      expect(find.text('Corporate Email Address'), findsOneWidget);
      expect(find.text('Company Website (Optional)'), findsOneWidget);
      expect(find.text('Industry / Primary Domain'), findsOneWidget);
      expect(find.text('Includes PhaseTwo Free Employer Starter Tier (\$0 CAD)'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Register Organization'), findsOneWidget);
    });
  });

  group('PhaseTwo Native Auth UI — ForgotPasswordScreen', () {
    testWidgets('Renders and validates email for password reset',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: ForgotPasswordScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Reset Password'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Send Password Reset Link'), findsOneWidget);

      // Validate empty field
      await tester.tap(find.widgetWithText(ElevatedButton, 'Send Password Reset Link'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your registered email.'), findsOneWidget);
    });

    testWidgets('Submits password reset request successfully',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      AuthApiService.instance.mockHandler = (String url, Map<String, String> fields) async {
        return const AuthResult.success(
          successMessage: 'If an account exists, password reset instructions have been sent.',
        );
      };

      await tester.pumpWidget(
        const MaterialApp(
          home: ForgotPasswordScreen(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'e.g. name@domain.ca'),
        'registered@phasetwo.ca',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Send Password Reset Link'));
      await tester.pumpAndSettle();

      expect(find.byType(AuthFeedbackBanner), findsOneWidget);
      expect(find.text('If an account exists, password reset instructions have been sent.'), findsOneWidget);
    });
  });

  group('PhaseTwo Native Auth UI — Service Layer Security & Session', () {
    test('AuthSessionService enforces role segregation', () async {
      final session = AuthSessionService.instance;
      await session.clearSession();

      // Candidate login
      await session.setVerifiedSession(
        authenticated: true,
        sessionToken: 'candidate_ci_session_token',
        role: 'candidate',
        email: 'candidate@phasetwo.ca',
      );

      expect(session.isAuthenticated, isTrue);
      expect(session.isCandidate, isTrue);
      expect(session.isEmployer, isFalse);

      // Employer login
      await session.setVerifiedSession(
        authenticated: true,
        sessionToken: 'employer_ci_session_token',
        role: 'employer',
        email: 'recruiter@company.ca',
      );

      expect(session.isAuthenticated, isTrue);
      expect(session.isCandidate, isFalse);
      expect(session.isEmployer, isTrue);

      // Logout clears session
      await session.clearSession();
      expect(session.isAuthenticated, isFalse);
      expect(session.userRole, isNull);
      expect(session.sessionToken, isNull);
    });

    test('AuthApiService handles network timeout gracefully', () async {
      AuthApiService.instance.mockHandler = (String url, Map<String, String> fields) async {
        throw const SocketException('Connection timed out');
      };

      final result = await AuthApiService.instance.loginCandidate(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, contains('Unable to connect to PhaseTwo'));
    });
  });
}
