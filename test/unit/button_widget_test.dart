import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis/email_summary.dart';
import 'package:jarvis/widgets/email_buttons.dart';

void main() {
  testWidgets('Tap Personal button navigates to Personal screen',
      (WidgetTester tester) async {
    // Build EmailSum widget
    await tester.pumpWidget(MaterialApp(home: EmailSum()));

    // Tap Personal button
    await tester.tap(find.text('Personal'));
    await tester.pumpAndSettle();

    // Verify if CombinedScreen with 'Personal' title is pushed
    expect(find.byWidgetPredicate((widget) =>
        widget is CombinedScreen && widget.title == 'Personal'), findsOneWidget);
  });

  testWidgets('Tap Promotions button navigates to Promotions screen',
      (WidgetTester tester) async {
    // Build EmailSum widget
    await tester.pumpWidget(MaterialApp(home: EmailSum()));

    // Tap Promotions button
    await tester.tap(find.text('Promotions'));
    await tester.pumpAndSettle();

    // Verify if CombinedScreen with 'Promotions' title is pushed
    expect(find.byWidgetPredicate((widget) =>
        widget is CombinedScreen && widget.title == 'Promotions'), findsOneWidget);
  });

  testWidgets('Tap Arrangements button navigates to Arrangements screen',
      (WidgetTester tester) async {
    // Build EmailSum widget
    await tester.pumpWidget(MaterialApp(home: EmailSum()));

    // Tap Arrangements button
    await tester.tap(find.text('Arrangements'));
    await tester.pumpAndSettle();

    // Verify if CombinedScreen with 'Arrangements' title is pushed
    expect(find.byWidgetPredicate((widget) =>
        widget is CombinedScreen && widget.title == 'Arrangements'), findsOneWidget);
  });

  testWidgets('Tap Others button navigates to Others screen',
      (WidgetTester tester) async {
    // Build EmailSum widget
    await tester.pumpWidget(MaterialApp(home: EmailSum()));

    // Tap Others button
    await tester.tap(find.text('Others'));
    await tester.pumpAndSettle();

    // Verify if CombinedScreen with 'Others' title is pushed
    expect(find.byWidgetPredicate((widget) =>
        widget is CombinedScreen && widget.title == 'Others'), findsOneWidget);
  });
}