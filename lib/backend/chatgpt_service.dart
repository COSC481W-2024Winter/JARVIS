import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatGPTService {
  final String apiKey;
  final String apiUrl;

  ChatGPTService(
      {required this.apiKey,
      this.apiUrl = 'https://api.openai.com/v1/chat/completions'});

  Future<String> generateCompletion(String prompt) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo-16k',
        'messages': [
          {'role': 'user', 'content': prompt}
        ],
        'max_tokens': 14000,
      }),
    );

    switch (response.statusCode) {
      case 200:
        final jsonResponse = jsonDecode(response.body);
        final generatedText = jsonResponse['choices'][0]['message']['content'];
        return generatedText.trim();
      case 401:
        final jsonResponse = jsonDecode(response.body);
        final errorMessage = jsonResponse['error']['message'];
        if (errorMessage.contains('Invalid Authentication')) {
          throw Exception(
              'Invalid Authentication. Ensure the correct API key and requesting organization are being used.');
        } else if (errorMessage.contains('Incorrect API key provided')) {
          throw Exception(
              'Incorrect API key provided. Ensure the API key used is correct, clear your browser cache, or generate a new one.');
        } else if (errorMessage.contains(
            'You must be a member of an organization to use the API')) {
          throw Exception(
              'You must be a member of an organization to use the API. Contact OpenAI to get added to a new organization or ask your organization manager to invite you to an organization.');
        } else {
          throw Exception(
              'Authentication failed. ${jsonResponse['error']['message']}');
        }
      case 429:
        final jsonResponse = jsonDecode(response.body);
        final errorMessage = jsonResponse['error']['message'];
        if (errorMessage.contains('Rate limit reached for requests')) {
          throw Exception(
              'Rate limit reached for requests. Pace your requests and read the Rate limit guide.');
        } else if (errorMessage.contains('You exceeded your current quota')) {
          throw Exception(
              'You exceeded your current quota. Buy more credits or learn how to increase your limits.');
        } else {
          throw Exception(
              'Rate limiting error. ${jsonResponse['error']['message']}');
        }
      case 500:
        throw Exception(
            'The server had an error while processing your request. Retry your request after a brief wait and contact OpenAI if the issue persists. Check the status page.');
      case 503:
        throw Exception(
            'The engine is currently overloaded. Please retry your request after a brief wait.');
      default:
        throw Exception(
            'Failed to generate completion. Status code: ${response.statusCode}');
    }
  }
}
