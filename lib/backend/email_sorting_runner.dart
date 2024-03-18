import 'package:jarvis/backend/email_fetch_service.dart';
import 'package:jarvis/backend/email_gmail_class.dart';
import 'package:jarvis/backend/email_sort_controller.dart';

class EmailSortingRunner {
  final EmailFetchingService _emailFetchingService;
  final EmailSortController _emailSortController;

  EmailSortingRunner({
    required EmailFetchingService emailFetchingService,
    required EmailSortController emailSortController,
  })  : _emailFetchingService = emailFetchingService,
        _emailSortController = emailSortController;

  Future<List<EmailMessage>> sortEmails(String accessToken, int count) async {
    // Fetch emails
    List<EmailMessage> fetchedEmails =
        await _emailFetchingService.fetchEmails(accessToken, count);

    // Convert EmailMessages to a suitable format for EmailSortController
    List<Map<String, String>> emailsToCategorize = fetchedEmails.map((email) {
      return {
        "Subject": email.subject,
        "Body": email.body,
      };
    }).toList();

    // Categorize emails using EmailSortController
    List<Map<String, dynamic>> categorizedEmailData =
        await _emailSortController.categorizeEmailsList(emailsToCategorize);

    // Convert back to List<EmailMessage> with categories
    return fetchedEmails.map((email) {
      final categorizedData = categorizedEmailData.firstWhere(
        (element) =>
            element["Subject"] == email.subject &&
            element["Body"] == email.body,
        orElse: () => {"Category": "Uncategorized"},
      );
      return EmailMessage(
        id: email.id,
        subject: email.subject,
        body: email.body,
        category: categorizedData["Category"],
      );
    }).toList();
  }
}
