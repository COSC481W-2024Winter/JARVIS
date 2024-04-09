import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis/backend/weather_service.dart';
import 'package:flutter/material.dart';

void main() {
  test('WeatherService processWeatherData method processes data correctly', () async {
    // Initialize Widgets binding
    WidgetsFlutterBinding.ensureInitialized();

    // Example JSON response from the OpenWeatherMap API
    const jsonResponse = '''
    {
      "weather": [{"main": "Clouds", "description": "overcast clouds"}],
      "main": {"temp": 10.0, "temp_min": 8.0, "temp_max": 12.0},
      "wind": {"speed": 5.0},
      "name": "Test City"
    }''';

    // Parse the JSON string to a Map
    final Map<String, dynamic> jsonMap = jsonDecode(jsonResponse);

    // Create an instance of WeatherService
    final weatherService = WeatherService();

    // Call processWeatherData with the parsed JSON
    final Map<String, String> result = weatherService.processWeatherData(jsonMap);

    // Assertions to verify the correctness of the processed data
    expect(result['condition'], equals('Clouds'));
    expect(result['temperature'], equals('10.0°F'));
    expect(result['summary'], contains('Test City'));
    expect(result['summary'], contains('Clouds'));
    expect(result['summary'], contains('10.0°F'));
    expect(result['summary'], contains('5.0'));
  });
}