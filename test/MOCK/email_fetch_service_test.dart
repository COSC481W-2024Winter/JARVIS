// This is basically useless, but if we had bugs before we start hammering the gmail API, this is how you would do it.

import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:jarvis/backend/email_fetch_service.dart';
import 'package:jarvis/backend/email_gmail_class.dart';

// Create a MockClient class by extending Mock and implementing the http.Client interface
class MockClient extends Mock implements http.Client {}

void main() {
  group('EmailFetchingService', () {
    // Initialize the mock client
    late MockClient client;
    late EmailFetchingService service;

    setUp(() {
      client = MockClient();
      service = EmailFetchingService(client: client);
    });

    test('fetches emails successfully', () async {
      final accessToken = 'fake_access_token';

      // Stub the HTTP calls
      // When the client gets a request to the messages endpoint, return a successful response
      when(() => client.get(
            Uri.parse('https://gmail.googleapis.com/gmail/v1/users/me/messages?maxResults=10'),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => http.Response('{"messages": [{"id": "123", "threadId": "abc"}]}', 200));

      // When the client gets a request to the message details endpoint, return a successful response
      when(() => client.get(
            Uri.parse('https://gmail.googleapis.com/gmail/v1/users/me/messages/123'),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => http.Response('{"id": "123", "threadId": "abc"}', 200));

      // Execute the function under test
      final emails = await service.fetchEmails(accessToken, 10);

      // Verify the results
      expect(emails, isA<List<EmailMessage>>());
      expect(emails.length, 1);
      expect(emails.first.id, '123');
      expect(emails.first.threadId, 'abc');
    });
  });
}