import 'dart:io';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

void main() {
  setUpAll(() async {
    // Load environment variables from .test_env
    dotenv.testLoad(fileInput: File('test/data/.env.test').readAsStringSync());
  });

  group('ProfileScreenState', () {
    late FakeFirebaseFirestore firestore;
    setUp(() {
      firestore = FakeFirebaseFirestore();
    });

    test('loads and saves profile data correctly', () async {
      final userData = {
        'fullName': 'Kevin',
        'age': '30',
        'story':
            'I am an online retailer on multiple sites selling a variety of items. Some of his sales happen automatically, while others require directly communicating with interested customers.',
      };
      final mockUser = MockUser(uid: 'test');
      final auth = MockFirebaseAuth(mockUser: mockUser);
      final userDoc = firestore.collection('users').doc(auth.currentUser?.uid);
      await userDoc.set(userData);

      // Act: Load the profile data
      final loadedData = await userDoc.get();

      // Assert: Check that the loaded profile data is correct
      expect(loadedData.data()?['fullName'], 'Kevin');
      expect(loadedData.data()?['age'], '30');
      expect(loadedData.data()?['story'],
          'I am an online retailer on multiple sites selling a variety of items. Some of his sales happen automatically, while others require directly communicating with interested customers.');

      // Act: Change and save the profile data
      final newUserData = {
        'fullName': 'Jimmy',
        'age': '37',
        'story':
            'I\'ve been a project manager for a mid-sized tech company for the past five years.',
      };
      await userDoc.set(newUserData);

      // Assert: Check that the saved profile data is correct
      final savedData = await userDoc.get();
      expect(savedData.data()?['fullName'], 'Jimmy');
      expect(savedData.data()?['age'], '37');
      expect(savedData.data()?['story'],
          'I\'ve been a project manager for a mid-sized tech company for the past five years.');

      // Now use the saved profile data in the ChatGPT test
      final apiKey = dotenv.env['CHATGPT_KEY'];
      expect(apiKey, isNotNull, reason: 'API key not found in .test_env');

      // Create a request body with the saved user profile data
      final userProfileStr =
          'name: ${savedData.data()?['fullName']}, age: ${savedData.data()?['age']}, story: ${savedData.data()?['story']}';
      final body = jsonEncode({
        'model': 'gpt-4',
        'messages': [
          {
            'role': 'system',
            'content':
                'You are a friendly personal assistant. You have access to the following user profile information: $userProfileStr. Your responses will be relatively more concise, more like a conversation.'
          },
          {'role': 'user', 'content': 'What is my name? Age? What kind of work do I do?'}
        ],
        'max_tokens': 100,
        'temperature': 0.7,
      });

      // Send a POST request to the ChatGPT API with the request body
      final url = Uri.parse('https://api.openai.com/v1/chat/completions');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: body,
      );

      // Check the status code of the response
      expect(response.statusCode, 200,
          reason: 'Failed to send user profile to ChatGPT');

      // Parse the response body
      final responseBody = jsonDecode(response.body);

      // Print the GPT result
      print(
          'GPT Response: ${responseBody['choices'][0]['message']['content']}');
    });
  });
}
