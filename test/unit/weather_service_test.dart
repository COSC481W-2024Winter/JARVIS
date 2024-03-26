import 'dart:convert'; // Add this import to use jsonDecode
import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis/backend/weather_service.dart';
import 'package:flutter/material.dart';


void main() {
  test('WeatherService processWeatherData method processes data correctly', () async {
    // Initialize Widgets binding
    WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter engine is initialized

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
    final String result = await weatherService.processWeatherData(jsonMap, "Test City");

    // Assertions to verify the correctness of the processed data
    expect(result, contains("Test City"));
    expect(result, contains("Clouds"));
    expect(result, contains("10.0°C"));
    //expect(result, contains("8.0°C"));
   // expect(result, contains("12.0°C"));
    expect(result, contains("5.0"));
  });
}
