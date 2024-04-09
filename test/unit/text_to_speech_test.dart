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

  //make tests for speak method
  test('TextToSpeech speak method should call speak method from FlutterTts', () async {
    when(mockFlutterTts.speak("Hello, world!")).thenAnswer((_) => Future.value(0));
    await textToSpeech.speak('Hello, world!');
    verify(mockFlutterTts.speak("Hello, world!")).called(1);

    when(mockFlutterTts.speak("Hola, mundo!")).thenAnswer((_) => Future.value(0));
    await textToSpeech.speak('Hola, mundo!');
    verify(mockFlutterTts.speak("Hola, mundo!")).called(1);

    when(mockFlutterTts.speak("你好，世界！")).thenAnswer((_) => Future.value(0));
    await textToSpeech.speak('你好，世界！');
    verify(mockFlutterTts.speak("你好，世界！")).called(1);
  });

  //make tests for setLanguage and setPitch methods
  test('TextToSpeech setLanguage method should call setLanguage method from FlutterTts', () async {
    when(mockFlutterTts.setLanguage("en-US")).thenAnswer((_) => Future.value(0));
    await textToSpeech.setLanguage('en-US');
    verify(mockFlutterTts.setLanguage("en-US")).called(1);

    when(mockFlutterTts.setLanguage("es-ES")).thenAnswer((_) => Future.value(0));
    await textToSpeech.setLanguage('es-ES');
    verify(mockFlutterTts.setLanguage("es-ES")).called(1);

    when(mockFlutterTts.setLanguage("zh-CN")).thenAnswer((_) => Future.value(0));
    await textToSpeech.setLanguage('zh-CN');
    verify(mockFlutterTts.setLanguage("zh-CN")).called(1);
  });

  test('TextToSpeech setPitch method should call setPitch method from FlutterTts', () async {
    when(mockFlutterTts.setPitch(1.0)).thenAnswer((_) => Future.value(0));
    await textToSpeech.setPitch(1.0);
    verify(mockFlutterTts.setPitch(1.0)).called(1);

    when(mockFlutterTts.setPitch(0.5)).thenAnswer((_) => Future.value(0));
    await textToSpeech.setPitch(0.5);
    verify(mockFlutterTts.setPitch(0.5)).called(1);

    when(mockFlutterTts.setPitch(2.0)).thenAnswer((_) => Future.value(0));
    await textToSpeech.setPitch(2.0);
    verify(mockFlutterTts.setPitch(2.0)).called(1);
  });

  //make tests for stop method
  test('TextToSpeech stop method should call stop method from FlutterTts', () async {
    when(mockFlutterTts.stop()).thenAnswer((_) => Future.value(0));
    await textToSpeech.stop();
    verify(mockFlutterTts.stop()).called(1);
  });
}
