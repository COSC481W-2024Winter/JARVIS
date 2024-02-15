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
  // Hugging Face API URL and Authorization token
  final String _apiUrl = "https://api-inference.huggingface.co/models/emarron/JARVIS-email-sorter";
  final String _apiToken = API_TOKEN; // Secure your API token

  // Method to categorize a list of emails
  Future<List<Map<String, dynamic>>> categorizeEmailsList(List<Map<String, String>> emails) async {
    var headers = {
      'Authorization': 'Bearer $_apiToken',
      'Content-Type': 'application/json',
    };

    List<Map<String, dynamic>> categorizedEmails = [];

    for (var email in emails) {
      // Combine subject and body with a separator for the model
      String emailText = "${email["Subject"]} [SEP] ${email["Body"]}";

      // Prepare the request body
      var response = await http.post(
        Uri.parse(_apiUrl),
        headers: headers,
        body: json.encode({"inputs": emailText}),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        // Assuming the response structure is {'label': 'category_label', ...}
        var categoryLabel = jsonResponse['label'];
        categorizedEmails.add({
          "Subject": email["Subject"],
          "Body": email["Body"],
          "Category": categoryLabel,
        });
      } else {
        // Handle error or invalid response
        print('Request failed with status: ${response.statusCode}.');
        categorizedEmails.add({
          "Subject": email["Subject"],
          "Body": email["Body"],
          "Category": "Error or invalid response",
        });
      }
    }

    return categorizedEmails;
  }
}
