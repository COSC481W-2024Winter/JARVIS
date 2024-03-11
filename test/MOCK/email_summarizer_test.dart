import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis/backend/local_storage_service.dart';
import 'package:jarvis/backend/chatgpt_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jarvis/backend/email_summarizer.dart';


class MockChatGPTService extends Mock implements ChatGPTService {}

void main() {
  late EmailSummarizer emailSummarizer;
  late LocalStorageService storageService;
  late MockChatGPTService mockChatGPTService;

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
    mockChatGPTService = MockChatGPTService();
    emailSummarizer = EmailSummarizer(
      storageService: storageService,
      chatGPTService: mockChatGPTService,
    );
  });

  tearDown(() async {
    await storageService.clearAllData();
  });

  test('summarizeEmails should retrieve data, generate summaries, and save them to local storage', () async {
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

    when(() => mockChatGPTService.generateCompletion(any())).thenAnswer((_) async => 'Mocked summary');

    // Act
    await emailSummarizer.summarizeEmails();

    // Assert
    verify(() => mockChatGPTService.generateCompletion(any())).called(4);

    expect((await storageService.getData('summary_emails_companyBusinessStrategy'))['summary'], equals('Mocked summary'));
  expect((await storageService.getData('summary_emails_purelyPersonal'))['summary'], equals('Mocked summary'));
  expect((await storageService.getData('summary_emails_logisticArrangements'))['summary'], equals('Mocked summary'));
  expect((await storageService.getData('summary_emails_documentEditingCheckingCollaboration'))['summary'], equals('Mocked summary'));
  });
}