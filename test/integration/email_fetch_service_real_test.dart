import 'dart:io';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test/test.dart';
import 'package:jarvis/backend/email_fetch_service.dart';
import 'package:jarvis/backend/email_gmail_class.dart';

void main() {
  group('EmailFetchingReal Tests', () {
    late EmailFetchingService emailService;
    late String accessToken;

    setUpAll(() async {
      // Load the .env file
      dotenv.testLoad(fileInput: File('.env').readAsStringSync());

      // Retrieve the SORTER_KEY from the environment variables
      accessToken = dotenv.env['JARVISTEST684_EMAIL_TEMP']!;
      if (accessToken.isEmpty) {
        throw Exception('JARVISTEST684_EMAIL_TEMP not found in .env file');
      }

      emailService = EmailFetchingService();
    });

    test('Fetch emails successfully', () async {
      try {
        final emails = await emailService.fetchEmails(accessToken, 10);
        expect(emails, isA<List<EmailMessage>>());
        expect(emails.length, isNonZero);
        for (var email in emails) {
          print('Email ID: ${email.id},Subject: ${email.subject}, Body: ${email.body}');
          // You can print more details or perform other checks here
        }
        // You can add more assertions here based on your expected outcomes
      } catch (e) {
        fail('Failed to fetch emails: $e');
      }
    });

    // Add more tests as needed
  });
}
