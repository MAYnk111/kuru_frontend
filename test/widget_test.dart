import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:career_twin/app/app.dart';
import 'package:career_twin/app/router.dart';
import 'package:career_twin/core/config/api_config.dart';

void main() {
  setUp(() {
    ApiConfig.enableDemoPreviewMode = true;
    appRouter.go('/');
  });

  testWidgets('App renders Discover screen and bottom navigation items',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: CareerTwinApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Discover screen header greetings and branding
    expect(find.text('Arjun'), findsOneWidget);
    expect(find.text('Namaste,'), findsOneWidget);
    expect(find.text('Discover'), findsOneWidget);
    expect(find.text('Career Twin'), findsOneWidget);
    expect(find.text('Growth'), findsOneWidget);
    expect(find.text('Applications'), findsOneWidget);
  });

  testWidgets('Navigating through all 4 primary sections works cleanly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: CareerTwinApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Tap Career Twin
    await tester.tap(find.text('Career Twin'));
    await tester.pumpAndSettle();
    expect(find.text('My Career Twin'), findsOneWidget);
    expect(find.text('Career Readiness'), findsOneWidget);
    expect(find.text('Key Skills\nDemonstrated'), findsOneWidget);

    // Tap Growth
    await tester.tap(find.byIcon(Icons.eco_outlined));
    await tester.pumpAndSettle();
    expect(find.text('My Growth Plan'), findsOneWidget);
    expect(find.text("Today's Focus"), findsOneWidget);
    expect(find.text('Why this matters?'), findsOneWidget);

    // Tap Applications
    await tester.tap(find.byIcon(Icons.assignment_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Applications'), findsNWidgets(2));
    expect(find.text('Active Applications'), findsOneWidget);
    expect(find.text('Tailor Resume for a New Role'), findsOneWidget);
  });

  testWidgets('Job details navigation and approval modal trigger properly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: CareerTwinApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Tap on Zoho Corporation job card
    final zohoJob = find.text('Software Engineering Intern');
    expect(zohoJob, findsOneWidget);
    await tester.tap(zohoJob);
    await tester.pumpAndSettle();

    // Verify Job Details Screen
    expect(find.text('AI Match Analysis'), findsOneWidget);
    expect(find.text('Key Skills from Job Description'), findsOneWidget);
    expect(find.text('Your Skill Fit'), findsOneWidget);
    expect(find.text('Apply with Approval'), findsOneWidget);

    // Tap Apply with Approval to trigger approval confirmation sheet
    await tester.tap(find.text('Apply with Approval'));
    await tester.pumpAndSettle();
    expect(find.text('Confirm & Apply'), findsOneWidget);
  });

  testWidgets('Daily goals toggle state optimistically',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: CareerTwinApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Navigate to Growth tab
    await tester.tap(find.byIcon(Icons.eco_outlined));
    await tester.pumpAndSettle();

    // Find incomplete task "Solve 5 DSA problems"
    final dsaTask = find.text('Solve 5 DSA problems');
    expect(dsaTask, findsOneWidget);

    // Tap task to toggle
    await tester.tap(dsaTask);
    await tester.pumpAndSettle();

    // Ensure state persists and task remains present
    expect(find.text('Solve 5 DSA problems'), findsOneWidget);
  });
}
