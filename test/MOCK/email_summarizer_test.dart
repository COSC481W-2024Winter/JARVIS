import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis/backend/local_storage_service.dart';
import 'package:jarvis/backend/email_summarizer.dart';
import 'package:flutter/services.dart';

void main() {
  late EmailSummarizer emailSummarizer;
  late LocalStorageService storageService;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    const MethodChannel('plugins.flutter.io/path_provider')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return '.';
      }
      return null;
    });

    storageService = LocalStorageService();
    emailSummarizer = EmailSummarizer(storageService: storageService);
  });

  tearDown(() async {
    await storageService.clearAllData();
  });

  test('summarizeEmails should retrieve data and mock send to ChatGPT', () async {
    // Arrange
    List<Map<String, dynamic>> companyBusinessStrategyEmails = [
      {'Subject': 'Business Strategy 1', 'Body': 'Content of email 1'},
      {'Subject': 'Business Strategy 2', 'Body': 'Content of email 2'},
    ];
    List<Map<String, dynamic>> purelyPersonalEmails = [
      {'Subject': 'Personal Email 1', 'Body': 'Content of personal email 1'},
    ];
    List<Map<String, dynamic>> logisticArrangementsEmails = [
      {'Subject': 'Logistic Arrangement 1', 'Body': 'Content of logistic email 1'},
    ];
    List<Map<String, dynamic>> documentEditingEmails = [
      {'Subject': 'Document Editing 1', 'Body': 'Content of document editing email 1'},
    ];

    await storageService.saveData('emails_companyBusinessStrategy', {'emails': companyBusinessStrategyEmails});
    await storageService.saveData('emails_purelyPersonal', {'emails': purelyPersonalEmails});
    await storageService.saveData('emails_logisticArrangements', {'emails': logisticArrangementsEmails});
    await storageService.saveData('emails_documentEditingCheckingCollaboration', {'emails': documentEditingEmails});

    // Act
    await emailSummarizer.summarizeEmails();

    // Assert
    // Add assertions based on the expected prompt content
  });
}