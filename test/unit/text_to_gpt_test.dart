import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis/backend/text_to_gpt_service.dart';


void main() {
  group('ChatGPTService', () {
    test('sendToChatGPT returns generated text when request is successful',
        () async {
      final chatGPTService = text_to_gpt_service();

      final result = await chatGPTService.send_to_GPT('Hello', 'talk');

      expect(result, isA<String>());
      expect(result, isNotEmpty);
    });

    test('sendToChatGPT returns empty string when input is empty', () async {
      final chatGPTService = text_to_gpt_service();

      final result = await chatGPTService.send_to_GPT('', 'talk');

      expect(result, equals(''));
    });

    test('sendToChatGPT returns empty string when type is not "talk"',
        () async {
      final chatGPTService = text_to_gpt_service();

      final result = await chatGPTService.send_to_GPT('Hello', 'other');

      expect(result, equals(''));
    });
  });
}
