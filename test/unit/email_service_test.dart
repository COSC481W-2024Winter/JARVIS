import 'package:jarvis/backend/email_gmail_class.dart';
import 'package:test/test.dart';

void main() {
  group('Email Parsing', () {
    test('parses email messages from JSON', () {
      const responseBody = '''
        {
          "messages": [
            {"id": "12345", "threadId": "67890"},
            {"id": "54321", "threadId": "09876"}
          ]
        }
      ''';

      List<EmailMessage> emails = parseEmails(responseBody);

      expect(emails, isA<List<EmailMessage>>());
      expect(emails.length, equals(2));
      expect(emails[0].id, equals('12345'));
      expect(emails[0].threadId, equals('67890'));
      expect(emails[1].id, equals('54321'));
      expect(emails[1].threadId, equals('09876'));
    });
  });
}
