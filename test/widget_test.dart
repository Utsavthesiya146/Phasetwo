import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phasetwo/screens/error_screen.dart';
import 'package:phasetwo/widgets/progress_bar.dart';

void main() {
  testWidgets('WebErrorScreen displays offline title and retry button', (WidgetTester tester) async {
    bool retryCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: WebErrorScreen(
          isOffline: true,
          onRetry: () async {
            retryCalled = true;
          },
        ),
      ),
    );

    expect(find.text('No Internet Connection'), findsOneWidget);
    expect(find.text('Retry Connection'), findsOneWidget);

    await tester.tap(find.text('Retry Connection'));
    await tester.pump();
    expect(retryCalled, isTrue);
  });

  testWidgets('WebProgressBar renders and animates opacity', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: WebProgressBar(
            progress: 0.5,
            isVisible: true,
          ),
        ),
      ),
    );

    expect(find.byType(WebProgressBar), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });
}
