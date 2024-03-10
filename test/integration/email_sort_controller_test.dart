import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test/test.dart';
import 'package:jarvis/backend/email_sort_service.dart'; // Update this import according to the new file structure

// Mock implementation of LocalStorageService for testing purposes
class MockLocalStorageService {
  final Map<String, List<Map<String, dynamic>>> storage = {};

  Future<void> writeJson(String key, List<Map<String, dynamic>> data) async {
    storage[key] = data;
  }

  List<Map<String, dynamic>>? readJson(String key) {
    return storage[key];
  }
}


void main() {
  group('Email Sorting and Storing Integration Test', () {
    late EmailSorter emailSorter;
    late MockLocalStorageService mockStorageService;

    setUpAll(() async {
      // Initialize EmailSorter with a mock API token
      dotenv.testLoad(fileInput: File('.env').readAsStringSync());
      // Retrieve the SORTER_KEY from the environment variables
      final apiToken = dotenv.env['SORTER_KEY'];
      if (apiToken == null) {
        throw Exception('SORTER_KEY not found in .env file');
      }

      // Initialize EmailSorter with the API token
      emailSorter = EmailSorter(apiToken: apiToken);

      // Initialize the mock storage service
      mockStorageService = MockLocalStorageService();
    });

    test('emails are categorized and stored correctly', () async {
      // Sample emails for testing
      List<Map<String, String>> sampleEmails = [
        {"Subject": "RE: NERC Statements on Impact of Security Threats on RTOs",
        "Body": "I agree with Joe. The IOUs will point to NERC as an objective third party on these issues."},
        {"Subject": "Strategy Meeting", "Body": "Let's discuss our business strategy."},
        {"Subject": "Lunch?", "Body": "Are you free for lunch today?"},
        // Add more samples as needed for testing
      ];

      // Categorize and store each email
      for (var email in sampleEmails) {
        var categorizedEmail = await emailSorter.categorizeEmail(email);
        print('Subject: ${categorizedEmail["Subject"]}, Body: ${categorizedEmail["Body"]}, Category: ${categorizedEmail["Category"]}');
        String categoryKey = 'emails_${categorizedEmail["Category"]}';
        List<Map<String, dynamic>> categoryList = mockStorageService.readJson(categoryKey) ?? [];
        categoryList.add(categorizedEmail);
        await mockStorageService.writeJson(categoryKey, categoryList);
      }

      // Assertions to verify that emails are stored under correct categories
      expect(mockStorageService.readJson('emails_companyBusinessStrategy'), isNotNull);
      expect(mockStorageService.readJson('emails_logisticArrangements'), isNotNull);
      // Add more assertions as necessary for each category
    });
  });
}
