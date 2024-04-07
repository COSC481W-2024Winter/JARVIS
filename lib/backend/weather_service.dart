import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'text_to_speech.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class WeatherService {
  final http.Client client;
  final text_to_speech tts;

  WeatherService({http.Client? client, text_to_speech? tts})
      : this.client = client ?? http.Client(),
        this.tts = tts ?? text_to_speech();

  Future<String> fetchWeather() async {
    await dotenv.load();
    final apiKey = dotenv.env['OPENWEATHERMAP_API_KEY'];
    if (apiKey == null) throw Exception('API key not found.');

    // Get the user's current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );

    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=imperial';
    final response = await this.client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final weatherSummary = processWeatherData(data);

      // Use the Text to Speech service to read out the weather summary
      await this.tts.speak(weatherSummary, Language.english);
      return weatherSummary;
    } else {
      print(
          'Failed to fetch weather data. Status code: ${response.statusCode}');
      return 'Failed to fetch weather data.';
    }
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      // Permission granted, proceed with fetching weather data
      fetchWeather();
    } else {
      // Permission denied, handle accordingly (e.g., show an error message)
      print('Location permission denied');
    }
  }

  Future<void> stopSpeaking() async {
    await tts.stop();
  }

  String processWeatherData(Map<String, dynamic> data) {
    final condition = data['weather'][0]['main'];
    final temp = data['main']['temp'].toStringAsFixed(1);
    final windSpeed = data['wind']['speed'].toStringAsFixed(1);
    final locationName = data['name'];

    return "Today in $locationName, the sky is $condition. The current temperature is $temp°F. Wind speed is at $windSpeed meters per second.";
  }
}
