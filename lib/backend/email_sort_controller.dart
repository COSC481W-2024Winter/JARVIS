import 'package:jarvis/backend/email_sort_service.dart';

class EmailSortController {
  final EmailSorter _emailSorter;

  EmailSortController({required EmailSorter emailSorter}) : _emailSorter = emailSorter;

  Future<List<Map<String, dynamic>>> categorizeEmailsList(List<Map<String, String>> emails) async {
    List<Map<String, dynamic>> categorizedEmails = [];

    for (var email in emails) {
      String emailText = _emailSorter.truncateText("${email["Subject"]} [SEP] ${email["Body"]}", 512);

      var bestCategory = await _emailSorter.getBestCategory(emailText);
      if (bestCategory != null) {
        categorizedEmails.add({
          "Subject": email["Subject"],
          "Body": email["Body"],
          "Category": bestCategory.toString().split('.').last,
        });
      } else {
        categorizedEmails.add({
          "Subject": email["Subject"],
          "Body": email["Body"],
          "Category": "No relevant category found",
        });
      }
    }

    return categorizedEmails;
  }
}