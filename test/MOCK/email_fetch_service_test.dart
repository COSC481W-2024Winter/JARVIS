import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:jarvis/backend/email_fetch_service.dart';
import 'package:jarvis/backend/email_gmail_class.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('EmailFetchingService', () {
    // Mock HTTP client
    late MockClient mockClient;

    // Initialize mock client
    setUp(() {
      mockClient = MockClient();
    });

    // Test for fetching emails
    test('fetches emails successfully', () async {
      final service = EmailFetchingService(client: mockClient);
      final accessToken = 'dummy_access_token';
      final count = 10;
      
      // Setup mock client response
      when(mockClient.get(Uri.parse('https://gmail.googleapis.com/gmail/v1/users/me/messages?maxResults=$count'),
          headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('{"messages": [{"id": "123", "threadId": "abc"}]}', 200));

      when(mockClient.get(Uri.parse('https://gmail.googleapis.com/gmail/v1/users/me/messages/123'),
          headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('{"id": "123", "threadId": "abc"}', 200));

      // Execute the function
      var emails = await service.fetchEmails(accessToken, count);

      // Verify the results
      expect(emails, isA<List<EmailMessage>>());
      expect(emails.length, 1);
      expect(emails[0].id, '123');
      expect(emails[0].threadId, 'abc');
    });

    // Test for handling errors
    test('throws an exception if unable to fetch emails', () {
      final service = EmailFetchingService(client: mockClient);
      final accessToken = 'dummy_access_token';
      final count = 10;

      // Setup mock client to return an error response
      when(mockClient.get(Uri.parse('https://gmail.googleapis.com/gmail/v1/users/me/messages?maxResults=$count'),
          headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // Check that an exception is thrown
      expect(service.fetchEmails(accessToken, count), throwsException);
    });
  });
}