import 'dart:convert';
import 'package:http/http.dart' as http;

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
  final String _apiUrl = "https://api-inference.huggingface.co/models/emarron/JARVIS-email-sorter";
  final String _apiToken;

  EmailSorter({required String apiToken}) : _apiToken = apiToken;

  EmailCategory _mapLabelToCategory(String label) {
    switch (label) {
      case 'LABEL_0':
        return EmailCategory.companyBusinessStrategy;
      case 'LABEL_1':
        return EmailCategory.purelyPersonal;
      case 'LABEL_2':
        return EmailCategory.personalButProfessional;
      case 'LABEL_3':
        return EmailCategory.logisticArrangements;
      case 'LABEL_4':
        return EmailCategory.employmentArrangements;
      case 'LABEL_5':
        return EmailCategory.documentEditingCheckingCollaboration;
      case 'LABEL_6':
        return EmailCategory.emptyMessageDueToMissingAttachment;
      case 'LABEL_7':
        return EmailCategory.emptyMessage;
      default:
        throw Exception('Unknown label: $label');
    }
  }

  String truncateText(String text, int maxLength) {
    // Ensure the text does not exceed the maxLength
    return text.length > maxLength ? text.substring(0, maxLength) : text;
  }

  Future<List<Map<String, dynamic>>> categorizeEmailsList(List<Map<String, String>> emails) async {
    var headers = {
      'Authorization': 'Bearer $_apiToken',
      'Content-Type': 'application/json',
    };

    List<Map<String, dynamic>> categorizedEmails = [];
    int delayMilliseconds = 1000; // Start with 1 second delay
    const int minimumDelay = 100; // Minimum delay of 0.1 seconds
    const int adjustmentAmount = 100; // Decrease delay by 100 milliseconds after each request

    for (var email in emails) {
      // Truncate the concatenated subject and body to a conservative character limit
      // Adjust this limit as needed to approximate the model's token limit
      String emailText = truncateText("${email["Subject"]} [SEP] ${email["Body"]}", 512); // Example limit

      var response = await http.post(
        Uri.parse(_apiUrl),
        headers: headers,
        body: json.encode({"inputs": emailText}),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var bestPrediction = jsonResponse[0][0];
        var categoryLabel = _mapLabelToCategory(bestPrediction['label']).toString().split('.').last;
        categorizedEmails.add({
          "Subject": email["Subject"],
          "Body": email["Body"],
          "Category": categoryLabel,
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
        print('Response body: ${response.body}');
        categorizedEmails.add({
          "Subject": email["Subject"],
          "Body": email["Body"],
          "Category": "Error or invalid response",
        });
      }

      // Dynamically adjust the delay
      await Future.delayed(Duration(milliseconds: delayMilliseconds));
      if (delayMilliseconds > minimumDelay) {
        delayMilliseconds -= adjustmentAmount;
      }
    }

    return categorizedEmails;
  }
}
