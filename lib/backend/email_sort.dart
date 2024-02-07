// lib/backend/email_sort.dart
import 'dart:math';

enum EmailCategory {
  companyBusinessStrategy,
  purelyPersonal,
  personalButProfessional,
  logisticArrangements,
  employmentArrangements,
  documentEditingCheckingCollaboration,
  emptyMessageDueToMissingAttachment,
  emptyMessage,
}

class EmailSorter {
  final Random _random = Random();

  // Existing method to categorize a single email (for reference)
  EmailCategory categorizeEmailDummy(String emailContent) {
    List<EmailCategory> categories = EmailCategory.values;
    return categories[_random.nextInt(categories.length)];
  }

  // New method to categorize a list of emails
  List<Map<String, dynamic>> categorizeEmailsList(List<Map<String, String>> emails) {
    List<EmailCategory> categories = EmailCategory.values;
    return emails.map((email) {
      return {
        "Subject": email["Subject"],
        "Body": email["Body"],
        "Category": categories[_random.nextInt(categories.length)].toString().split('.').last
      };
    }).toList();
  }
}

