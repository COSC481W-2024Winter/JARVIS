import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis/backend/email_gmail_class.dart';  // Adjust the import path according to your project structure
import 'package:jarvis/emails_screen.dart';  // Adjust the import path according to your project structure

void main() {
  // A group of tests for EmailsScreen
  group('EmailsScreen Tests', () {
    // Sample email data
    final List<EmailMessage> mockEmails = [
      EmailMessage(id: "1", subject: "Test Subject 1", body: "Test Body 1", category: "Category 1"),
      EmailMessage(id: "2", subject: "Test Subject 2", body: "Test Body 2", category: "Category 2"),
    ];

    testWidgets('Displays email subjects, bodies, and categories correctly', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(home: EmailsScreen(emails: mockEmails)));

      // Verify that the titles of the emails are displayed.
      expect(find.text('Test Subject 1'), findsOneWidget);
      expect(find.text('Test Subject 2'), findsOneWidget);

      // Verify that the bodies of the emails are displayed.
      expect(find.text('Test Body 1'), findsOneWidget);
      expect(find.text('Test Body 2'), findsOneWidget);

      // Verify that the categories of the emails are displayed.
      expect(find.text('Category 1'), findsOneWidget);
      expect(find.text('Category 2'), findsOneWidget);
    });
  });
}
