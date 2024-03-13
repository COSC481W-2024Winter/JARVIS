//todo: seperate each category to use %given API%, also if over token limit, seperate into two requests at a logical break between emails.
// todo: (if possible), get empty emails to stop showing up in other categories.

import 'package:jarvis/backend/email_sort_service.dart';
import 'package:jarvis/backend/local_storage_service.dart';
import 'package:jarvis/backend/chatgpt_service.dart';

class EmailSummarizer {
  final LocalStorageService storageService;
  final ChatGPTService chatGPTService;


  EmailSummarizer({
    required this.storageService,
    required this.chatGPTService,
  });

  Future<Map<String, String>> summarizeEmails() async {
    Map<String, String> summaries = {};

    List<Future> futures = [];

    for (var category in EmailCategory.values) {
      String key = getCategoryKey(category);
      dynamic emailsData = await storageService.getData(key);

      if (emailsData != null && emailsData is Map<String, dynamic>) {
        List<Map<String, dynamic>> emails =
            List<Map<String, dynamic>>.from(emailsData['emails'] ?? []);

        String emailContents = emails.map((email) {
          String subject = email['Subject'] ?? '';
          String body = truncateText(email['Body'] ?? '', 512);
          return "$subject\n$body";
        }).join("\n\n");

        String prompt =
            "These are ${category.toString().split('.').last} emails, please summarize the contents in 500 words or less:\n$emailContents";

        String apiKey = getApiKeyForCategory(category);

        futures.add(
            chatGPTService.generateCompletion(prompt, apiKey).then((summary) {
          print('Summary for $category:\n$summary');
          summaries[getCategoryKey(category)] = summary;
        }).catchError((e) {
          print('Error generating summary for $category: $e');
        }));
      } else {
        print("No emails found for category: $category");
      }
    }

    await Future.wait(futures);

    return summaries;
  }

  String getCategoryKey(EmailCategory category) {
    switch (category) {
      case EmailCategory.companyBusinessStrategy:
        return 'emails_companyBusinessStrategy';
      case EmailCategory.purelyPersonal:
        return 'emails_purelyPersonal';
      case EmailCategory.logisticArrangements:
        return 'emails_logisticArrangements';
      case EmailCategory.documentEditingCheckingCollaboration:
        return 'emails_documentEditingCheckingCollaboration';
      default:
        return 'emails_other';
    }
  }

  String truncateText(String text, int maxLength) {
    return text.length > maxLength ? text.substring(0, maxLength) : text;
  }

  String getApiKeyForCategory(EmailCategory category) {
    switch (category) {
      case EmailCategory.companyBusinessStrategy:
        return 'CHATGPT_BUSINESS_KEY';
      case EmailCategory.purelyPersonal:
        return 'CHATGPT_PERSONAL_KEY';
      case EmailCategory.logisticArrangements:
        return 'CHATGPT_ARRANGEMENT_KEY';
      case EmailCategory.documentEditingCheckingCollaboration:
        return 'CHATGPT_DOC_EDIT_KEY';
      default:
        return 'CHATGPT_BUSINESS_KEY';
    }
  }
}
