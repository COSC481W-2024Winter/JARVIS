import 'package:flutter_gpt_tokenizer/flutter_gpt_tokenizer.dart';
import 'package:jarvis/backend/email_sort_service.dart';
import 'package:jarvis/backend/local_storage_service.dart';
import 'package:jarvis/backend/chatgpt_service.dart';

class EmailSummarizer {
  final LocalStorageService storageService;
  final ChatGPTService chatGPTService;
  late final Tokenizer _tokenizer;

  EmailSummarizer({
    required this.storageService,
    required this.chatGPTService,
  }) {
    _tokenizer = Tokenizer();
  }

  Future<Map<String, String>> summarizeEmails() async {
    Map<String, String> summaries = {};
    List<Future> futures = [];

    for (var category in EmailCategory.values) {
      String key = getCategoryKey(category);
      dynamic emailsData = await storageService.getData(key);

      if (emailsData != null && emailsData is Map<String, dynamic>) {
        List<Map<String, dynamic>> emails =
            List<Map<String, dynamic>>.from(emailsData['emails'] ?? []);

        List<String> emailContentList = emails.map((email) {
          String subject = email['Subject'] ?? '';
          String body = truncateText(email['Body'] ?? '', 512);
          return "$subject\n$body";
        }).toList();

        String apiKey = getApiKeyForCategory(category);

        futures.add(generateSummaryWithTokenLimit(
          category,
          emailContentList,
          apiKey,
          summaries,
        ));
      } else {
        print("No emails found for category: $category");
      }
    }

    await Future.wait(futures);
    return summaries;
  }

  Future<void> generateSummaryWithTokenLimit(
    EmailCategory category,
    List<String> emailContentList,
    String apiKey,
    Map<String, String> summaries,
  ) async {
    int maxTokens = 1000;
    List<String> currentChunk = [];
    int currentTokenCount = 0;

    for (String emailContent in emailContentList) {
      int emailTokenCount = await _getTokenCount(emailContent);

      if (currentTokenCount + emailTokenCount <= maxTokens) {
        currentChunk.add(emailContent);
        currentTokenCount += emailTokenCount;
      } else {
        await generateSummaryForChunk(
            category, currentChunk, apiKey, summaries);
        currentChunk = [emailContent];
        currentTokenCount = emailTokenCount;
      }
    }

    if (currentChunk.isNotEmpty) {
      await generateSummaryForChunk(category, currentChunk, apiKey, summaries);
    }
  }

  Future<int> _getTokenCount(String text) async {
    return await _tokenizer.count(text, modelName: "gpt-3.5-turbo");
  }

  Future<void> generateSummaryForChunk(
    EmailCategory category,
    List<String> emailChunk,
    String apiKey,
    Map<String, String> summaries,
  ) async {
    String emailContents = emailChunk.join("\n\n");
    String prompt =
        "These are ${category.toString().split('.').last} emails, please summarize the contents in 500 words or less:\n$emailContents";

    try {
      String summary = await chatGPTService.generateCompletion(prompt, apiKey);
      print('Summary for $category:\n$summary');
      summaries[getCategoryKey(category)] =
          summaries.containsKey(getCategoryKey(category))
              ? '${summaries[getCategoryKey(category)]!} $summary'
              : summary;
    } catch (e) {
      print('Error generating summary for $category: $e');
    }
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

  void dispose() {
    _tokenizer.dispose();
  }
}
