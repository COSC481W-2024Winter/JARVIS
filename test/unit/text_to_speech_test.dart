import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:jarvis/backend/text_to_speech.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'text_to_speech_test.mocks.dart';

@GenerateMocks([FlutterTts])
void main() {
  late MockFlutterTts mockFlutterTts;
  late text_to_speech textToSpeech;

  setUp(() {
    mockFlutterTts = MockFlutterTts();
    textToSpeech = text_to_speech(flutterTts: mockFlutterTts);
  });

  test('TextToSpeech speak method should set language correctly for English', () async {
    when(mockFlutterTts.setLanguage("en-US")).thenAnswer((_) => Future.value(0));
    when(mockFlutterTts.speak("Hello, world!")).thenAnswer((_) => Future.value(0));
    when(mockFlutterTts.setPitch(1.0)).thenAnswer((_) => Future.value(0));

    await textToSpeech.speak('Hello, world!', Language.english);

    verify(mockFlutterTts.setLanguage("en-US")).called(1);
    verify(mockFlutterTts.speak("Hello, world!")).called(1);
    verify(mockFlutterTts.setPitch(1.0)).called(1);
  });

  test('TextToSpeech speak method should set language correctly for Spanish', () async {
    when(mockFlutterTts.setLanguage("es-ES")).thenAnswer((_) => Future.value(0));
    when(mockFlutterTts.speak("Hola, mundo!")).thenAnswer((_) => Future.value(0));
    when(mockFlutterTts.setPitch(1.0)).thenAnswer((_) => Future.value(0));

    await textToSpeech.speak('Hola, mundo!', Language.spanish);

    verify(mockFlutterTts.setLanguage("es-ES")).called(1);
    verify(mockFlutterTts.speak("Hola, mundo!")).called(1);
    verify(mockFlutterTts.setPitch(1.0)).called(1);
  });

  test('TextToSpeech speak method should set language correctly for Chinese', () async {
    when(mockFlutterTts.setLanguage("zh-CN")).thenAnswer((_) => Future.value(0));
    when(mockFlutterTts.speak("你好，世界！")).thenAnswer((_) => Future.value(0));
    when(mockFlutterTts.setPitch(1.0)).thenAnswer((_) => Future.value(0));

    await textToSpeech.speak('你好，世界！', Language.chinese);

    verify(mockFlutterTts.setLanguage("zh-CN")).called(1);
    verify(mockFlutterTts.speak("你好，世界！")).called(1);
    verify(mockFlutterTts.setPitch(1.0)).called(1);
  });
}
