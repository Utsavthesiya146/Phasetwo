import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phasetwo/screens/candidate_section_screen.dart';
import 'package:phasetwo/screens/employer_section_screen.dart';
import 'package:phasetwo/screens/home_screen.dart';
import 'package:phasetwo/screens/jobs_screen.dart';
import 'package:phasetwo/widgets/bottom_nav_bar.dart';
import 'package:phasetwo/widgets/custom_header.dart';

void main() {
  group('PhaseTwo Responsive Multi-Screen & Accessibility Tests', () {
    final List<Map<String, dynamic>> testDevices = <Map<String, dynamic>>[
      <String, dynamic>{'name': '320px Compact Android / iPhone SE 1', 'size': const Size(320, 640)},
      <String, dynamic>{'name': '360px Standard Compact Android', 'size': const Size(360, 740)},
      <String, dynamic>{'name': '393px iPhone 14/15/16', 'size': const Size(393, 852)},
      <String, dynamic>{'name': '412px Google Pixel 8 / Galaxy S24', 'size': const Size(412, 915)},
      <String, dynamic>{'name': '430px iPhone 15/16 Pro Max', 'size': const Size(430, 932)},
      <String, dynamic>{'name': '768px Tablet Layout', 'size': const Size(768, 1024)},
    ];

    for (final device in testDevices) {
      final String deviceName = device['name'] as String;
      final Size deviceSize = device['size'] as Size;

      testWidgets('HomeScreen renders with 0 overflow on $deviceName', (WidgetTester tester) async {
        tester.view.physicalSize = deviceSize;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          MaterialApp(
            home: HomeScreen(
              onNavigateToTab: (_) {},
              onOpenUrl: (_) {},
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Experience Is Your Greatest Asset'), findsOneWidget);
        expect(find.text('Find Work'), findsOneWidget);
        expect(find.text('Post a Role'), findsOneWidget);
        expect(find.text('Candidates'), findsOneWidget);
        expect(find.text('Employers'), findsOneWidget);
      });

      testWidgets('CustomBottomNavBar renders 4 tabs with 0 overflow on $deviceName',
          (WidgetTester tester) async {
        tester.view.physicalSize = deviceSize;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        int tappedTab = -1;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              bottomNavigationBar: CustomBottomNavBar(
                currentIndex: 0,
                onTap: (int index) => tappedTab = index,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Jobs'), findsOneWidget);
        expect(find.text('Candidate'), findsOneWidget);
        expect(find.text('Employer'), findsOneWidget);
        expect(find.text('Web Portal'), findsNothing);

        await tester.tap(find.text('Employer'));
        await tester.pump();
        expect(tappedTab, equals(3));
      });

      testWidgets('CustomAppHeader renders cleanly on $deviceName', (WidgetTester tester) async {
        tester.view.physicalSize = deviceSize;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        bool searchTapped = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: CustomAppHeader(
                onOpenDrawer: () {},
                onOpenSearch: () => searchTapped = true,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byTooltip('Open Menu'), findsOneWidget);
        expect(find.byTooltip('Search Jobs'), findsOneWidget);
        expect(find.byTooltip('Refresh'), findsNothing);
        expect(find.byTooltip('Live PhaseTwo Web'), findsNothing);

        await tester.tap(find.byTooltip('Search Jobs'));
        await tester.pump();
        expect(searchTapped, isTrue);
      });

      testWidgets('JobsScreen renders search fields & chips on $deviceName',
          (WidgetTester tester) async {
        tester.view.physicalSize = deviceSize;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          MaterialApp(
            home: JobsScreen(
              onOpenUrl: (_) {},
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Search Jobs & Flexible Gigs'), findsOneWidget);
        expect(find.text('Search on PhaseTwo Live'), findsOneWidget);
      });

      testWidgets('CandidateSectionScreen renders on $deviceName', (WidgetTester tester) async {
        tester.view.physicalSize = deviceSize;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          MaterialApp(
            home: CandidateSectionScreen(
              onOpenUrl: (_) {},
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Candidate Login'), findsOneWidget);
        expect(find.text('Join PhaseTwo'), findsOneWidget);
      });

      testWidgets('EmployerSectionScreen renders on $deviceName', (WidgetTester tester) async {
        tester.view.physicalSize = deviceSize;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          MaterialApp(
            home: EmployerSectionScreen(
              onOpenUrl: (_) {},
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Post a Role'), findsOneWidget);
        expect(find.text('Recruiter Login'), findsOneWidget);
      });
    }

    testWidgets('Accessibility text scaling (1.5x and 2.0x) does not cause RenderFlex overflow',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 740);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      for (final double scale in <double>[1.3, 1.5, 2.0]) {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(
                size: const Size(360, 740),
                textScaler: TextScaler.linear(scale),
              ),
              child: Scaffold(
                appBar: CustomAppHeader(
                  onOpenDrawer: () {},
                  onOpenSearch: () {},
                ),
                body: HomeScreen(
                  onNavigateToTab: (_) {},
                  onOpenUrl: (_) {},
                ),
                bottomNavigationBar: CustomBottomNavBar(
                  currentIndex: 0,
                  onTap: (_) {},
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final bottomNavFinder = find.byType(CustomBottomNavBar);
        expect(find.descendant(of: bottomNavFinder, matching: find.text('Home')), findsOneWidget);
        expect(find.descendant(of: bottomNavFinder, matching: find.text('Jobs')), findsOneWidget);
        expect(find.descendant(of: bottomNavFinder, matching: find.text('Candidate')), findsOneWidget);
        expect(find.descendant(of: bottomNavFinder, matching: find.text('Employer')), findsOneWidget);
      }
    });
  });
}
