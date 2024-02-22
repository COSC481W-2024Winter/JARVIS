import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis/email_service.dart';
import 'package:jarvis/emails_screen.dart';

void main() {
  testWidgets('EmailsScreen displays list of emails correctly', (WidgetTester tester) async {
    // Setup: Create test data
    final List<EmailMessage> testEmails = [
      EmailMessage(id: 'email1', threadId: 'thread1'),
      EmailMessage(id: 'email2', threadId: 'thread2'),
    ];

    // Execution: Render EmailsScreen with test data
    await tester.pumpWidget(MaterialApp(
      home: EmailsScreen(emails: testEmails),
    ));

    // Verification: Check for correct number of emails
    expect(find.byType(ListTile), findsNWidgets(testEmails.length));

    // Check for correct content
    for (var email in testEmails) {
      expect(find.text('Email ID: ${email.id}'), findsOneWidget);
      expect(find.text('Thread ID: ${email.threadId}'), findsOneWidget);
    }
  });
}
