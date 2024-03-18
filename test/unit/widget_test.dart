// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis/main.dart';
import 'package:jarvis/z_arrangements.dart';
import 'package:jarvis/z_others.dart';
import 'package:jarvis/z_personal.dart';
import 'package:jarvis/z_promotions.dart';
import 'package:jarvis/email_summary.dart';
import 'package:jarvis/auth_gate.dart';
void main() {
 /* testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
  */

  testWidgets('Tap Personal button navigates to Personal screen', (WidgetTester tester) async {
    // Build EmailSum widget
    await tester.pumpWidget(MaterialApp(home: EmailSum()));

    // Tap Personal button
    await tester.tap(find.text('Personal'));
    await tester.pumpAndSettle();

    // Verify if Personal screen is pushed
    expect(find.byType(Personal), findsOneWidget);
  });

  testWidgets('Tap Promotions button navigates to Promotions screen', (WidgetTester tester) async {
    // Build EmailSum widget
    await tester.pumpWidget(MaterialApp(home: EmailSum()));

    // Tap Promotions button
    await tester.tap(find.text('Promotions'));
    await tester.pumpAndSettle();

    // Verify if Promotions screen is pushed
    expect(find.byType(Promotions), findsOneWidget);
  });

  testWidgets('Tap Arrangements button navigates to Arrangements screen', (WidgetTester tester) async {
    // Build EmailSum widget
    await tester.pumpWidget(MaterialApp(home: EmailSum()));

    // Tap Arrangements button
    await tester.tap(find.text('Arrangements'));
    await tester.pumpAndSettle();

    // Verify if Arrangements screen is pushed
    expect(find.byType(Arrangements), findsOneWidget);
  });

  testWidgets('Tap Others button navigates to Others screen', (WidgetTester tester) async {
    // Build EmailSum widget
    await tester.pumpWidget(MaterialApp(home: EmailSum()));

    // Tap Others button
    await tester.tap(find.text('Others'));
    await tester.pumpAndSettle();

    // Verify if Others screen is pushed
    expect(find.byType(Others), findsOneWidget);
  });

  //testWidgets('Tap Log out button navigates to AuthGate screen', (WidgetTester tester) async {
    // Build EmailSum widget
   // await tester.pumpWidget(MaterialApp(home: EmailSum()));

    // Tap Log out button
   // await tester.tap(find.text('Log out'));
   // await tester.pumpAndSettle();

    // Verify if AuthGate screen is pushed
    //expect(find.byType(AuthGate), findsOneWidget);
  //});
  
}
