import 'package:flutter_tts/flutter_tts.dart';

class text_to_speech {
  final FlutterTts flutterTts;

  text_to_speech({FlutterTts? flutterTts})
      : flutterTts = flutterTts ?? FlutterTts();

  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> stop() async {
    await flutterTts.stop();
  }

  Future<void> setLanguage(String language) async {
    await flutterTts.setLanguage(language);
  }

  Future<void> setPitch(double pitch) async {
    await flutterTts.setPitch(pitch);
  }
}
