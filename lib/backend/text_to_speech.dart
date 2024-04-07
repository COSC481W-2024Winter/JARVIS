import 'package:flutter_tts/flutter_tts.dart';

enum Language {
  english,
  spanish,
  chinese,
}

class text_to_speech {
  final FlutterTts flutterTts;

  text_to_speech({FlutterTts? flutterTts}) : flutterTts = flutterTts ?? FlutterTts();

  Future<void> speak(String text, Language language) async {
    String languageCode = _getLanguageCode(language);
    await flutterTts.setLanguage(languageCode);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  Future<void> stop() async {
    await flutterTts.stop();
  }

   String _getLanguageCode(Language language) {
    switch (language) {
      case Language.english:
        return "en-US";
      case Language.spanish:
        return "es-ES";
      case Language.chinese:
        return "zh-CN";
      default:
        throw Exception("Unsupported language: $language");
    }
  }
}

