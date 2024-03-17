import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis/backend/email_fetch_service.dart';
import 'package:jarvis/backend/email_gmail_class.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

// Define a fake Uri class to satisfy type checking
class FakeUri extends Fake implements Uri {}

void main() {
  // Register fallback values before tests are run
  setUpAll(() {
    registerFallbackValue(FakeUri());
    // Register other fallback values as needed
  });

  late MockClient client;
  late EmailFetchingService service;

  setUp(() {
    client = MockClient();
    service = EmailFetchingService(client: client);
  });

  group('EmailFetchingService tests', () {
    test('fetches emails successfully', () async {
      const accessToken = 'fake_access_token';
      // Define expected JSON response
      const messagesJson = '{"messages": [{"id": "123", "threadId": "abc"}]}';
      const messageDetailJson =
          '{"id": "123", "threadId": "abc", "payload": {"headers": [{"name": "Subject", "value": "Test Subject"}], "body": {"data": "VGVzdCBCb2R5"}}}';

      // Stub the HTTP calls
      when(() => client.get(
            any(that: isA<Uri>()),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => http.Response(messagesJson, 200));

      when(() => client.get(
            Uri.parse(
                'https://gmail.googleapis.com/gmail/v1/users/me/messages/123'),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => http.Response(messageDetailJson, 200));

      // Execute the function under test
      final emails = await service.fetchEmails(accessToken, 10);

      // Verify the results
      expect(emails, isA<List<EmailMessage>>());
      expect(emails.length, 1);
      expect(emails.first.id, '123');
      //expect(emails.first.threadId, 'abc');
      // Additional assertions for subject and body can be done here
    });
  });
}
