import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test/test.dart';
import 'package:jarvis/backend/email_sort_service.dart';
import 'package:jarvis/backend/email_sort_controller.dart';

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
    late EmailSortController emailSortController;
    late MockLocalStorageService mockStorageService;

    setUpAll(() async {
      // Initialize EmailSorter with a mock API token
      dotenv.testLoad(fileInput: File('.env').readAsStringSync());
      // Retrieve the SORTER_KEY from the environment variables
      final apiToken = dotenv.env['SORTER_KEY'];
      if (apiToken == null) {
        throw Exception('SORTER_KEY not found in .env file');
      }

      // Initialize EmailSorter and EmailSortController with the API token
      emailSorter = EmailSorter(apiToken: apiToken);
      emailSortController = EmailSortController(emailSorter: emailSorter);

      // Initialize the mock storage service
      mockStorageService = MockLocalStorageService();
    });

    test('emails are categorized and stored correctly', () async {
      // Read emails from the JSON file
      var file = File('test/data/uncategorized_emails_10.json');
      var content = await file.readAsString();
      List<dynamic> emailList = json.decode(content);

      // Convert the email list to the expected format
      List<Map<String, String>> emails = emailList.map((email) {
        return {
          "Subject": email["Subject"] as String,
          "Body": email["Body"] as String,
        };
      }).toList();

      // Categorize and store each email
      List<Map<String, dynamic>> categorizedEmails =
          await emailSortController.categorizeEmailsList(emails);

      for (var email in categorizedEmails) {
        String categoryKey = 'emails_${email["Category"]}';
        List<Map<String, dynamic>> categoryList = mockStorageService.readJson(categoryKey) ?? [];
        categoryList.add(email);
        await mockStorageService.writeJson(categoryKey, categoryList);
      }
      print('Contents of emails_companyBusinessStrategy:');
      print(mockStorageService.readJson('emails_companyBusinessStrategy'));

      print('Contents of emails_purelyPersonal:');
      print(mockStorageService.readJson('emails_purelyPersonal'));

      print('Contents of emails_logisticArrangements:');
      print(mockStorageService.readJson('emails_logisticArrangements'));

      print('Contents of emails_uncategorized:');
      print(mockStorageService.readJson('emails_uncategorized'));

      // Assertions to verify that emails are stored under correct categories or marked as uncategorized
      expect(mockStorageService.readJson('emails_companyBusinessStrategy'), isNotNull);
      // expect(mockStorageService.readJson('emails_purelyPersonal'), isNotNull);
      expect(mockStorageService.readJson('emails_logisticArrangements'), isNotNull);
      // expect(mockStorageService.readJson('emails_uncategorized'), isNotNull);
    });
  });
}