import 'dart:convert';
import 'dart:io';
import 'package:jarvis/backend/email_sort.dart';
import 'package:test/test.dart';
import 'package:logging/logging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  Logger.root.level = Level.ALL; // Log all messages
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  final Logger logger = Logger('EmailSorterTests');

    late EmailSorter emailSorter;

  group('EmailSorter Tests', () {
    setUpAll(() async {
      // Load the .env file
      dotenv.testLoad(fileInput: File('.env').readAsStringSync());
      // Retrieve the SORTER_KEY from the environment variables
      final apiToken = dotenv.env['SORTER_KEY'];
      if (apiToken == null) {
        throw Exception('SORTER_KEY not found in .env file');
      }

      // Initialize EmailSorter with the API token
      emailSorter = EmailSorter(apiToken: apiToken);
    });
    // Test for categorizing a list of emails provided directly in the test
    test('categorizeEmailsList assigns a category to each email', () async {
      List<Map<String, String>> emails = [
        {
          "Subject": "RE: NERC Statements on Impact of Security Threats on RTOs",
          "Body": "I agree with Joe. The IOUs will point to NERC as an objective third party on these issues."
        },
        {
          "Subject": "RE: NERC Meeting Today",
          "Body": "There was an all day meeting of the NERC/reliability legislation group today. This is a placeholder for the actual content."
        }
      ];

      var categorizedEmails = await emailSorter.categorizeEmailsList(emails);

      for (var email in categorizedEmails) {
        logger.info('Subject: ${email["Subject"]}, Body: ${email["Body"]}, Category: ${email["Category"]}');
        expect(email.keys, contains('Category'));
      }
    });

    // Test for reading emails from a JSON file, categorizing them, and verifying the categorization
    test('Categorize emails from JSON file', () async {
      var file = File('test/data/uncategorized_emails_10.json'); // Switching to 10 emails to avoid overloading the API calls alloted.
      var content = await file.readAsString();
      List<dynamic> emailList = json.decode(content);

      // Convert the dynamic list to the expected Map<String, String> structure
      List<Map<String, String>> emails = emailList.map<Map<String, String>>((email) => {
        "Subject": email["Subject"],
        "Body": email["Body"]
      }).toList();

      // Use EmailSorter to categorize emails
      var categorizedEmails = await emailSorter.categorizeEmailsList(emails);

      // Print and verify each categorized email
      for (var email in await categorizedEmails) {
        logger.info('Subject: ${email["Subject"]}, Body: ${email["Body"]}, Category: ${email["Category"]}');
        expect(email.keys, contains('Category')); // Verifies that 'Category' key exists
      }
    });
  });
}
