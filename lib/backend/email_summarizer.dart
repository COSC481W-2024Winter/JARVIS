import 'package:jarvis/backend/email_sort_service.dart';
import 'package:jarvis/backend/local_storage_service.dart';
import 'package:jarvis/backend/chatgpt_service.dart';

class EmailSummarizer {
  final LocalStorageService storageService;
  final ChatGPTService chatGPTService;

  EmailSummarizer({required this.storageService, required this.chatGPTService});

  Future<Map<String, String>> summarizeEmails() async {
    Map<String, String> summaries = {};

    for (var category in EmailCategory.values) {
      String key = getCategoryKey(category);
      dynamic emailsData = await storageService.getData(key);

      if (emailsData != null && emailsData is Map<String, dynamic>) {
        List<Map<String, dynamic>> emails = List<Map<String, dynamic>>.from(emailsData['emails'] ?? []);
        String emailContents = emails.map((email) => "${email['Subject']}\n${email['Body']}").join("\n\n");
        String prompt = "These are ${category.toString().split('.').last} emails, please summarize the contents in 500 words or less:\n$emailContents";

        try {
          String summary = await chatGPTService.generateCompletion(prompt);
          print('Summary for $category:\n$summary');

          // Add the summary to the map
          summaries[getCategoryKey(category)] = summary;
        } catch (e) {
          print('Error generating summary for $category: $e');
        }
      } else {
        print("No emails found for category: $category");
      }
    }

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
}