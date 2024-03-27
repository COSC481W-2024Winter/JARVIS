import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'text_to_speech.dart';

class WeatherService {
  final http.Client client;
  final text_to_speech tts;

  WeatherService({http.Client? client, text_to_speech? tts})
      : this.client = client ?? http.Client(),
        this.tts = tts ?? text_to_speech();

  Future<String> fetchWeather(String city) async {
    await dotenv.load();
    final apiKey = dotenv.env['OPENWEATHERMAP_API_KEY'];
    if (apiKey == null) throw Exception('API key not found.');

    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=imperial';

    final response = await this.client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final weatherSummary = processWeatherData(data, city);
      
      // Use the Text to Speech service to read out the weather summary
      await this.tts.speak(weatherSummary);
      return weatherSummary;
    } else {
      print('Failed to fetch weather data. Status code: ${response.statusCode}');
      return 'Failed to fetch weather data.';
    }
  }

  String processWeatherData(Map<String, dynamic> data, String city) {
    final condition = data['weather'][0]['main'];
    final temp = data['main']['temp'].toStringAsFixed(1);
    final windSpeed = data['wind']['speed'].toStringAsFixed(1);

    return "Today in $city, the sky is $condition . The current temperature is $temp°F , Wind speed is at $windSpeed meters per second.";
  }
}
