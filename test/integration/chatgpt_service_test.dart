import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jarvis/backend/chatgpt_service.dart'; // Update with the correct import path

void main() {
  late ChatGPTService chatGPTService;
  String? apiToken;

  setUpAll(() async {
    // Load the .env file
    dotenv.testLoad(fileInput: File('.env').readAsStringSync());
    // Retrieve the CHATGPT_KEY from the environment variables
    apiToken = dotenv.env['CHATGPT_KEY'];
  });

  setUp(() {
    // Initialize the ChatGPTService with the API token
    chatGPTService = ChatGPTService(apiKey: apiToken!);
  });

  test('generateCompletion should send "Hello, World!" to ChatGPT API and return a response', () async {
    // Arrange
    final prompt = 'Hello, World!';

    // Act
    final response = await chatGPTService.generateCompletion(prompt);

    // Assert
    expect(response, isNotEmpty);
    expect(response, isA<String>());
    print('ChatGPT response: $response');
  });
}