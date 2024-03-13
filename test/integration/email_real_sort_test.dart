import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test/test.dart';
import 'package:jarvis/backend/email_fetch_service.dart';
import 'package:jarvis/backend/email_gmail_class.dart';
import 'package:jarvis/backend/email_sort_service.dart';

void main() {
  group('EmailFetch and Sort Integration Tests', () {
    late EmailFetchingService emailFetchingService;
    late EmailSorter emailSorter;
    late String accessToken;
    late String apiToken;

    setUpAll(() async {
      // Load the .env file
      dotenv.testLoad(fileInput: File('.env').readAsStringSync());

      // Retrieve the necessary tokens from the environment variables
      accessToken = dotenv.env['JARVISTEST684_EMAIL_TEMP']!;
      apiToken = dotenv.env['SORTER_KEY']!;

      if (accessToken.isEmpty || apiToken.isEmpty) {
        throw Exception('Tokens not found in .env file');
      }

      // Initialize services
      emailFetchingService = EmailFetchingService();
      emailSorter = EmailSorter(apiToken: apiToken);
    });

    test('Fetch and sort emails successfully', () async {
      // Fetch emails
      final fetchedEmails = await emailFetchingService.fetchEmails(accessToken, 10);
      expect(fetchedEmails, isA<List<EmailMessage>>());

      // Prepare emails for sorting
      List<Map<String, String>> emailsToCategorize = fetchedEmails.map((email) => {
        "Subject": email.subject,
        "Body": email.body
      }).toList();

      // Sort emails
      final categorizedEmails = await emailSorter.categorizeEmailsList(emailsToCategorize);

      // Check results
      for (var email in categorizedEmails) {
        expect(email.keys, contains('Category'));
        // Output results for debug purposes
        print('Subject: ${email["Subject"]}, Category: ${email["Category"]}');
      }

      // Assert that all emails have a category assigned
      for (var email in categorizedEmails) {
        expect(email['Category'], isNotNull);
      }
    });
  });
}
