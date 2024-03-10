import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';
import 'package:logging/logging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jarvis/backend/email_sort_service.dart'; // Update this import according to the new file structure

void main() {
  Logger.root.level = Level.ALL; // Log all messages
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

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

    test('categorizeEmail assigns a category to a single email', () async {
      var email = {
        "Subject": "RE: NERC Statements on Impact of Security Threats on RTOs",
        "Body": "I agree with Joe. The IOUs will point to NERC as an objective third party on these issues."
      };

      var categorizedEmail = await emailSorter.categorizeEmail(email);

      print('Subject: ${categorizedEmail["Subject"]}, Body: ${categorizedEmail["Body"]}, Category: ${categorizedEmail["Category"]}');
      expect(categorizedEmail.keys, contains('Category'));
    });

    test('Categorize emails from JSON file and verify each email', () async {
      var file = File('test/data/uncategorized_emails_10.json');
      var content = await file.readAsString();
      List<dynamic> emailList = json.decode(content);

      for (var emailData in emailList) {
        Map<String, String> email = {
          "Subject": emailData["Subject"],
          "Body": emailData["Body"]
        };

        var categorizedEmail = await emailSorter.categorizeEmail(email);
        print('Subject: ${categorizedEmail["Subject"]}, Body: ${categorizedEmail["Body"]}, Category: ${categorizedEmail["Category"]}');
        expect(categorizedEmail.keys, contains('Category'));
      }
    });
  });
}
