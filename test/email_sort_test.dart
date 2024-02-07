import 'package:jarvis/backend/email_sort.dart';
import 'package:test/test.dart';

void main() {
  group('EmailSorter Tests', () {
    final EmailSorter emailSorter = EmailSorter();

    test('categorizeEmailsList assigns a category to each email', () {
      List<Map<String, String>> emails = [
        {
          "Subject": "RE: NERC Statements on Impact of Security Threats on RTOs",
          "Body": "I agree with Joe. The IOUs will point to NERC as an objective third party on these issues. "
        },
        {
          "Subject": "RE: NERC Meeting Today",
          "Body": "There was an all day meeting of the NERC/reliability legislation group today. [...]" // Ensure to replace [...] with the actual content
        }
      ];

      var categorizedEmails = emailSorter.categorizeEmailsList(emails);
      
      for (var email in categorizedEmails) {
        // Print each email's subject, body, and assigned category
        print('Subject: ${email["Subject"]}, Body: ${email["Body"]}, Category: ${email["Category"]}');
        
        expect(email.keys, contains('Category'));
      }
    });
  });
}
