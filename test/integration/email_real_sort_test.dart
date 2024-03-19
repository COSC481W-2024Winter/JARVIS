import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test/test.dart';
import 'package:jarvis/backend/email_fetch_service.dart';
import 'package:jarvis/backend/email_gmail_class.dart';
import 'package:jarvis/backend/email_sort_controller.dart';
import 'package:jarvis/backend/email_sort_service.dart';
import 'package:jarvis/backend/email_sorting_runner.dart';

void main() {
  group('EmailFetch and Sort Integration Tests', () {
    late EmailFetchingService emailFetchingService;
    late EmailSortController emailSortController;
    late EmailSortingRunner emailSortingRunner;
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
      emailSortController =
          EmailSortController(emailSorter: EmailSorter(apiToken: apiToken));
      emailSortingRunner = EmailSortingRunner(
        emailFetchingService: emailFetchingService,
        emailSortController: emailSortController,
      );
    });

    test('Fetch and sort emails successfully', () async {
      // Fetch and sort emails
      final sortedEmails = await emailSortingRunner.sortEmails(accessToken, 10);

      // Check results
      for (var email in sortedEmails) {
        expect(email, isA<EmailMessage>());
        expect(email.category, isNotNull);
        // Output results for debug purposes
        print('Subject: ${email.subject}, Category: ${email.category}');
      }

      // Assert that all emails have a category assigned
      for (var email in sortedEmails) {
        expect(email.category, isNotEmpty);
      }
    });
  });
}
