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

  test('TextToSpeech speak method should return true', () async {
    when(mockFlutterTts.speak('Hello, world!')).thenAnswer((_) async => 1);
    when(mockFlutterTts.setLanguage("en-US")).thenAnswer((_) async => 1);
    when(mockFlutterTts.setPitch(1.0)).thenAnswer((_) async => 1);


    await textToSpeech.speak('Hello, world!');

    verify(mockFlutterTts.speak('Hello, world!')).called(1);
    verify(mockFlutterTts.setLanguage("en-US")).called(1);
    verify(mockFlutterTts.setPitch(1.0)).called(1);
  });
}