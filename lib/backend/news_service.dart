import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class news_service {
  Future<List<String>> getTopNews() async {
    // Load the API key from the .env file
    final String apiKey = dotenv.env['NEWS_API_KEY']!;

    // Define the URL to fetch the top 3 news articles in the US
    final url = 'https://newsapi.org/v2/top-headlines?country=us&pageSize=3&apiKey=$apiKey';
    final response = await http.get(Uri.parse(url));

    // Check if the response is successful
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final articles = jsonData['articles'] as List<dynamic>;

      // Extract the content of each news article
      final newsContents = articles.map((article) {
        final content = article['content'] as String?;
        return content ?? '';
      }).toList();

      // Return the list of news contents if the response is successful
      return newsContents;
    } else {
      // Throw an exception if the response is not successful
      throw Exception('Failed to load news');
    }
  }
}