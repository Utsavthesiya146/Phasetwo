import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phasetwo/config/app_config.dart';
import 'package:phasetwo/screens/candidate_section_screen.dart';
import 'package:phasetwo/screens/employer_section_screen.dart';
import 'package:phasetwo/screens/home_screen.dart';
import 'package:phasetwo/screens/jobs_screen.dart';
import 'package:phasetwo/screens/main_shell.dart';
import 'package:phasetwo/widgets/app_drawer.dart';
import 'package:phasetwo/widgets/bottom_nav_bar.dart';
import 'package:phasetwo/widgets/custom_header.dart';

void main() {
  group('PhaseTwo Hybrid UI Widget Tests', () {
    testWidgets('HomeScreen renders Option B hero, metrics, work models and portals',
        (WidgetTester tester) async {
      int navigatedTab = -1;

      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(
            onNavigateToTab: (int index) => navigatedTab = index,
            onOpenUrl: (_) {},
          ),
        ),
      );

      // Verify Canadian header & Hero text
      expect(find.text("Experience Is Your Greatest Asset"), findsOneWidget);
      expect(find.text("Candidates"), findsOneWidget);
      expect(find.text("Employers"), findsOneWidget);
      expect(find.text("Who PhaseTwo Is For"), findsOneWidget);
      expect(find.text("Work Models We Support"), findsOneWidget);
      expect(find.text("Explore Top Categories"), findsOneWidget);

      // Tap on "Find Work" button
      await tester.tap(find.text('Find Work'));
      await tester.pump();
      expect(navigatedTab, equals(1));
    });

    testWidgets('JobsScreen renders keyword input, chips and executes search',
        (WidgetTester tester) async {
      String searchedUrl = '';

      await tester.pumpWidget(
        MaterialApp(
          home: JobsScreen(
            onOpenUrl: (String url) => searchedUrl = url,
          ),
        ),
      );

      expect(find.text('Search Jobs & Flexible Gigs'), findsOneWidget);
      expect(find.text('Keywords / Designations'), findsOneWidget);
      expect(find.text('Flexible Gig'), findsAtLeast(1));
      expect(find.text('10+ Years'), findsAtLeast(1));
      expect(find.text('Search on PhaseTwo Live'), findsOneWidget);

      // Enter search keywords
      await tester.enterText(
        find.widgetWithText(TextField, 'e.g. Director, VP, Advisor, Operations...'),
        'Operations',
      );
      await tester.pump();

      await tester.ensureVisible(find.text('Search on PhaseTwo Live'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Search on PhaseTwo Live'));
      await tester.pump();

      expect(searchedUrl, contains('search=Operations'));
    });

    testWidgets('CandidateSectionScreen renders candidate login and registration cards',
        (WidgetTester tester) async {
      String openedUrl = '';

      await tester.pumpWidget(
        MaterialApp(
          home: CandidateSectionScreen(
            onOpenUrl: (String url) => openedUrl = url,
          ),
        ),
      );

      expect(find.text('Your Experience is Your Greatest Asset'), findsOneWidget);
      expect(find.text('Candidate Login'), findsOneWidget);
      expect(find.text('Join PhaseTwo'), findsOneWidget);

      await tester.tap(find.text('Candidate Login'));
      await tester.pump();
      expect(openedUrl, equals(AppConfig.candidateLoginUrl));
    });

    testWidgets('EmployerSectionScreen renders post job and recruiter login cards',
        (WidgetTester tester) async {
      String openedUrl = '';

      await tester.pumpWidget(
        MaterialApp(
          home: EmployerSectionScreen(
            onOpenUrl: (String url) => openedUrl = url,
          ),
        ),
      );

      expect(find.text('Hire Proven Canadian Talent'), findsOneWidget);
      expect(find.text('Post a Role'), findsOneWidget);
      expect(find.text('Recruiter Login'), findsOneWidget);
      expect(find.text('Employer Listing Plans'), findsOneWidget);

      await tester.tap(find.text('Post a Role'));
      await tester.pump();
      expect(openedUrl, equals(AppConfig.postJobUrl));
    });

    testWidgets('CustomBottomNavBar highlights active tab and fires onTap with 4 clean tabs',
        (WidgetTester tester) async {
      int selectedTab = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: selectedTab,
              onTap: (int index) => selectedTab = index,
            ),
          ),
        ),
      );

      // Verify 4 compact tabs are present and Web Portal is completely removed
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Jobs'), findsOneWidget);
      expect(find.text('Candidate'), findsOneWidget);
      expect(find.text('Employer'), findsOneWidget);
      expect(find.text('Web Portal'), findsNothing);

      await tester.tap(find.text('Jobs'));
      await tester.pump();
      expect(selectedTab, equals(1));
    });

    testWidgets('CustomAppHeader renders title and actions without globe or refresh button',
        (WidgetTester tester) async {
      bool drawerOpened = false;
      bool searchOpened = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: CustomAppHeader(
              onOpenDrawer: () => drawerOpened = true,
              onOpenSearch: () => searchOpened = true,
              title: 'Jobs',
            ),
          ),
        ),
      );

      expect(find.text('Jobs'), findsOneWidget);

      await tester.tap(find.byTooltip('Open Menu'));
      await tester.pump();
      expect(drawerOpened, isTrue);

      await tester.tap(find.byTooltip('Search Jobs'));
      await tester.pump();
      expect(searchOpened, isTrue);

      // Ensure globe and refresh buttons are completely absent
      expect(find.byTooltip('Live PhaseTwo Web'), findsNothing);
      expect(find.byTooltip('Refresh'), findsNothing);
    });

    testWidgets('AppDrawer renders sections and dispatches callbacks',
        (WidgetTester tester) async {
      int navigatedTab = -1;
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          home: AppDrawer(
            onNavigateToTab: (int index) => navigatedTab = index,
            onOpenUrl: (_) {},
          ),
        ),
      );

      expect(find.text('Home Dashboard'), findsOneWidget);
      expect(find.text('Candidate Hub'), findsOneWidget);
      expect(find.text('Employer Hub'), findsOneWidget);

      await tester.tap(find.text('Candidate Hub'));
      await tester.pump();
      expect(navigatedTab, equals(2));
    });

    testWidgets('MainShellScreen renders native Option B Home Dashboard and navigates tabs',
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

      // Verify native Option B Home Dashboard is primary interface
      expect(find.text('Experience Is Your Greatest Asset'), findsOneWidget);
      expect(find.byType(HomeScreen), findsOneWidget);

      // Verify clean native header without redundant chrome
      expect(find.byTooltip('Open Menu'), findsOneWidget);
      expect(find.byTooltip('Search Jobs'), findsOneWidget);
      expect(find.byTooltip('Live PhaseTwo Web'), findsNothing);
      expect(find.byTooltip('Refresh'), findsNothing);

      // Navigate to Jobs tab
      final bottomNav = find.byType(CustomBottomNavBar);
      await tester.tap(find.descendant(of: bottomNav, matching: find.text('Jobs')));
      await tester.pumpAndSettle();
      expect(find.byType(JobsScreen), findsOneWidget);

      // Navigate to Candidate tab
      await tester.tap(find.descendant(of: bottomNav, matching: find.text('Candidate')));
      await tester.pumpAndSettle();
      expect(find.byType(CandidateSectionScreen), findsOneWidget);

      // Navigate to Employer tab
      await tester.tap(find.descendant(of: bottomNav, matching: find.text('Employer')));
      await tester.pumpAndSettle();
      expect(find.byType(EmployerSectionScreen), findsOneWidget);
    });
  });
}
