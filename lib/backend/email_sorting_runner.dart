import 'package:jarvis/backend/email_fetch_service.dart';
import 'package:jarvis/backend/email_gmail_class.dart';
import 'package:jarvis/backend/email_sort_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EmailSortingRunner {
  final EmailFetchingService _emailFetchingService;
  final EmailSorter _emailSorter;

  EmailSortingRunner({
    required EmailFetchingService emailFetchingService,
    required EmailSorter emailSorter,
  })  : _emailFetchingService = emailFetchingService,
        _emailSorter = emailSorter;

  Future<List<EmailMessage>> sortEmails(String accessToken, int count) async {
    // Fetch emails
    List<EmailMessage> fetchedEmails = await _emailFetchingService.fetchEmails(accessToken, count);

    // Convert EmailMessages to a suitable format for EmailSorter
    List<Map<String, String>> emailsToCategorize = fetchedEmails.map((email) {
      return {
        "Subject": email.subject,
        "Body": email.body,
      };
    }).toList();

    // Categorize emails
    List<Map<String, dynamic>> categorizedEmailData = await _emailSorter.categorizeEmailsList(emailsToCategorize);

    // Convert back to List<EmailMessage> with categories
    return fetchedEmails.map((email) {
      final categorizedData = categorizedEmailData.firstWhere(
        (element) => element["Subject"] == email.subject && element["Body"] == email.body,
        orElse: () => {"Category": "Uncategorized"},
      );
      return EmailMessage(
        id: email.id,
        subject: email.subject,
        body: email.body,
        category: categorizedData["Category"], // This assumes you've added a `category` field to EmailMessage
      );
    }).toList();
  }
}

