import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis/backend/email_sort_service.dart';
import 'package:jarvis/backend/email_sort_controller.dart';
import 'package:jarvis/backend/local_storage_service.dart';
import 'package:jarvis/backend/chatgpt_service.dart';
import 'package:jarvis/backend/email_summarizer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  group('Email Categorization and Summarization Integration Test', () {
    late EmailSorter emailSorter;
    late EmailSortController emailSortController;
    late EmailSummarizer emailSummarizer;
    late LocalStorageService storageService;
    late ChatGPTService chatGPTService;

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();

      const MethodChannel('plugins.flutter.io/path_provider')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'getApplicationDocumentsDirectory') {
          return '.';
        }
        return null;
      });

      // Load the .env file
      dotenv.testLoad(fileInput: File('.env').readAsStringSync());
      // Retrieve the SORTER_KEY from the environment variables
      final sorterToken = dotenv.env['SORTER_KEY'];
      if (sorterToken == null) {
        throw Exception('SORTER_KEY not found in .env file');
      }
      final businessKey = dotenv.env['CHATGPT_BUSINESS_KEY'];
      final arrangementKey = dotenv.env['CHATGPT_ARRANGEMENT_KEY'];
      final personalKey = dotenv.env['CHATGPT_PERSONAL_KEY'];
      final docEditKey = dotenv.env['CHATGPT_DOC_EDIT_KEY'];

      if (businessKey == null ||
          arrangementKey == null ||
          personalKey == null ||
          docEditKey == null) {
        throw Exception('One or more ChatGPT API keys not found in .env file');
      }

      // Initialize EmailSorter and EmailSortController with the API token
      emailSorter = EmailSorter(apiToken: sorterToken);
      emailSortController = EmailSortController(emailSorter: emailSorter);

      // Initialize LocalStorageService and ChatGPTService
      storageService = LocalStorageService();
      chatGPTService = ChatGPTService(apiKeys: {
        'CHATGPT_BUSINESS_KEY': businessKey,
        'CHATGPT_ARRANGEMENT_KEY': arrangementKey,
        'CHATGPT_PERSONAL_KEY': personalKey,
        'CHATGPT_DOC_EDIT_KEY': docEditKey,
      });
      emailSummarizer = EmailSummarizer(
        storageService: storageService,
        chatGPTService: chatGPTService,
      );

      // Override the default HttpClient with a real one
      HttpOverrides.global = null;
    });

    tearDownAll(() async {
      await storageService.clearAllData();
    });

    test('emails are categorized, stored, and summarized correctly', () async {
      await Future.delayed(Duration.zero, () async {
        // Read emails from the JSON file
        var file = File('test/data/uncategorized_emails_50.json');
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
          List<Map<String, dynamic>> categoryList =
              (await storageService.getData(categoryKey))?['emails']
                      ?.cast<Map<String, dynamic>>() ??
                  [];
          categoryList.add(email);
          await storageService.saveData(categoryKey, {'emails': categoryList});
        }

        // Generate summaries for each category
        Map<String, String> generatedSummaries =
            await emailSummarizer.summarizeEmails();
        await storageService.saveData('generatedSummaries', generatedSummaries);
        Map<String, String> savedSummaries =
            await storageService.getData('generatedSummaries');

        bool hasSummary = false;
        for (var category in EmailCategory.values) {
          String summaryKey = emailSummarizer.getCategoryKey(category);
          String? summary = savedSummaries[summaryKey];
          if (summary != null && summary.isNotEmpty) {
            hasSummary = true;
            //print('Summary for $category: $summary');
          }
        }
        expect(hasSummary, isTrue,
            reason: 'At least one category should have a non-null summary');
      });
    }, timeout: const Timeout(Duration(minutes: 15)));
  });
}
