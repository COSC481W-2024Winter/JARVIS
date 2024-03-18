import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jarvis/backend/chatgpt_service.dart';

void main() {
  late ChatGPTService chatGPTService;
  Map<String, String>? apiKeys;

  setUpAll(() async {
// Load the .env file
    dotenv.testLoad(fileInput: File('.env').readAsStringSync());
// Retrieve the API keys from the environment variables
    apiKeys = {
      'CHATGPT_BUSINESS_KEY': dotenv.env['CHATGPT_BUSINESS_KEY']!,
      'CHATGPT_ARRANGEMENT_KEY': dotenv.env['CHATGPT_ARRANGEMENT_KEY']!,
      'CHATGPT_PERSONAL_KEY': dotenv.env['CHATGPT_PERSONAL_KEY']!,
      'CHATGPT_DOC_EDIT_KEY': dotenv.env['CHATGPT_DOC_EDIT_KEY']!,
    };
  });

  setUp(() {
// Initialize the ChatGPTService with the API keys
    chatGPTService = ChatGPTService(apiKeys: apiKeys!);
  });

  test(
      'generateCompletion should send "Hello, World!" to ChatGPT API and return a response',
      () async {
// Arrange
    final prompt = 'Hello, World!';
    final apiKey = 'CHATGPT_BUSINESS_KEY';

// Act
    final response = await chatGPTService.generateCompletion(prompt, apiKey);

// Assert
    expect(response, isNotEmpty);
    expect(response, isA<String>());
    print('ChatGPT response: $response');
  });
}
