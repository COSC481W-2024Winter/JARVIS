import 'package:jarvis/backend/email_sort_service.dart';
import 'local_storage_service.dart'; // Assuming LocalStorageService is implemented

class EmailSortController {
  final EmailSorter emailSorter;
  final LocalStorageService storageService;

  EmailSortController({required this.emailSorter, required this.storageService});

  Future<void> categorizeAndStoreEmails(List<Map<String, String>> emails) async {
    Map<EmailCategory, List<Map<String, dynamic>>> categorizedEmails = {};

    for (var email in emails) {
      var categorizedEmail = await emailSorter.categorizeEmail(email);
      EmailCategory category = EmailCategory.values.firstWhere(
        (c) => c.toString() == 'EmailCategory.${categorizedEmail["Category"]}',
        orElse: () => EmailCategory.emptyMessage, // Default case or handle appropriately
      );

      if (!categorizedEmails.containsKey(category)) {
        categorizedEmails[category] = [];
      }

      categorizedEmails[category]!.add(categorizedEmail);
    }

    // Store the emails in their respective categories
    for (var category in categorizedEmails.keys) {
      String key = getCategoryKey(category);
      await storageService.writeJson({key: categorizedEmails[category]!});
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
        return 'emails_other'; // Handle other categories or introduce more cases as needed
    }
  }
}
