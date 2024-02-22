import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  setUpAll(() async {
  // Load environment variables from .test_env
    dotenv.testLoad(fileInput: File('test/data/.env.test').readAsStringSync());
  });
  String fullNameKey = "name";
  String ageKey = "age";
  String storyKey = "story";

  test('shared prefs test', () async {
    SharedPreferences.setMockInitialValues({
      fullNameKey: 'Kevin',
      ageKey: 'Unknown',
      storyKey: 'I am an online retailer on multiple sites selling a variety of items. Some of his sales happen automatically, while others require directly communicating with interested customers.',
    });

    final prefs = await SharedPreferences.getInstance();

    final fullName = prefs.getString(fullNameKey);
    final age = prefs.getString(ageKey);
    final story = prefs.getString(storyKey);

    print(fullName);
    print(age);
    print(story);

    expect(fullName, 'Kevin');
    expect(age, 'Unknown');
    expect(story, 'I am an online retailer on multiple sites selling a variety of items. Some of his sales happen automatically, while others require directly communicating with interested customers.');
  });

  test('shared prefs to GPT test', () async {
    SharedPreferences.setMockInitialValues({
      fullNameKey: 'Jimmy',
      ageKey: '37',
      storyKey: 'Ive been a project manager for a mid-sized tech company for the past five years.',
    });

    final prefs = await SharedPreferences.getInstance();

    final fullName = prefs.getString(fullNameKey);
    final age = prefs.getString(ageKey);
    final story = prefs.getString(storyKey);

    print(fullName);
    print(age);
    print(story);

    expect(fullName, 'Jimmy');
    expect(age, '37');
    expect(story, 'Ive been a project manager for a mid-sized tech company for the past five years.');

    final apiKey = dotenv.env['CHATGPT_KEY'];
    expect(apiKey, isNotNull, reason: 'API key not found in .test_env');

    // Replace the URL with the actual endpoint for OpenAI's ChatGPT
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4-1106-preview',
        "messages": [
          {
            "role": "user", 
            "content": "My name is $fullName, I am $age years old, and here's a little about me: $story. Actual question/action implemented here"
          }
        ]
      }),
    );

    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    // Check for 429 error specifically
    if (response.statusCode == 429) {
      expect(jsonResponse['error']['code'], 'insufficient_quota', reason: 'Quota exceeded, but this is expected for this test case.');
    } else {
      // For all other responses, expect a successful status code
      expect(response.statusCode, 200, reason: 'Failed to get response from ChatGPT');
    } 
  });
}
