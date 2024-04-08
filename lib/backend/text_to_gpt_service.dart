import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;

class text_to_gpt_service {
  static final String _apiKey = dotenv.env['CHATGPT_KEY']!;
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String> send_to_GPT(String wordsSpoken, String type) async {
    if (wordsSpoken.isEmpty) return '';

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    };

    final user = fba.FirebaseAuth.instance.currentUser;
    var userProfile = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    var body;
    if (type == "talk") {
      String userProfileStr = userProfile
          .data()!
          .entries
          .map((e) => '${e.key}: ${e.value}')
          .join(', ');

      print('User Profile: $userProfileStr');

      body = json.encode({
        "model": "gpt-4",
        "messages": [
          {
            "role": "system",
            "content":
                "You are a friendly personal assistant. You have access to the following user profile information: $userProfileStr. Your responses will be relatively more concise, more like a conversation."
          },
          {"role": "user", "content": wordsSpoken}
        ],
        "max_tokens": 100,
        "temperature": 0.7,
      });
    } else if(type == "news") {
      body = json.encode({
        "model": "gpt-3.5-turbo-16k",
        "messages": [
          {"role": "system", "content": "Your job is to summarize the news content into one or two sentences, don’t analyze anything, just summarize it"},
          {"role": "user", "content": wordsSpoken}
        ],
        "max_tokens": 100,
        "temperature": 0.7,
      });
    }

    var response =
        await http.post(Uri.parse(_apiUrl), headers: headers, body: body);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var generatedText = jsonResponse['choices'][0]['message']['content'];
      return generatedText.trim();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return '';
    }
  }
}
