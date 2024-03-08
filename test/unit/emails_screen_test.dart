import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis/backend/email_gmail_class.dart';
import 'package:jarvis/emails_screen.dart'; // Adjust the import path as needed

void main() {
  // Create a list of EmailMessage objects to use in the test
  final List<EmailMessage> mockEmails = [
    EmailMessage(id: '1', subject: 'Test Subject 1', body: 'Test Body 1', threadId: 't1', content: 'Placeholder Content 1'),
    EmailMessage(id: '2', subject: 'Test Subject 2', body: 'Test Body 2', threadId: 't2', content: 'Placeholder Content 2'),
  ];


  testWidgets('Displays a list of emails with subject and body', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(MaterialApp(
      home: EmailsScreen(emails: mockEmails),
    ));

    // Verify that the titles and subtitles of emails are displayed
    expect(find.text('Test Subject 1'), findsOneWidget);
    expect(find.text('Test Body 1'), findsOneWidget);
    expect(find.text('Test Subject 2'), findsOneWidget);
    expect(find.text('Test Body 2'), findsOneWidget);
  });
}
