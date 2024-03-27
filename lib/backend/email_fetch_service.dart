import 'package:http/http.dart' as http;
import 'dart:convert';
import 'email_gmail_class.dart';

class EmailFetchingService {
  final http.Client client;

  EmailFetchingService({http.Client? client})
      : this.client = client ?? http.Client();

  Future<List<EmailMessage>> fetchEmails(String accessToken, int count) async {
    final String url =
        'https://gmail.googleapis.com/gmail/v1/users/me/messages?maxResults=$count';
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<EmailMessage> emails = [];
      for (var message in data['messages']) {
        final emailDetailsResponse = await client.get(
          Uri.parse(
              'https://gmail.googleapis.com/gmail/v1/users/me/messages/${message['id']}'),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Accept': 'application/json',
          },
        );

        if (emailDetailsResponse.statusCode == 200) {
          final emailData = json.decode(emailDetailsResponse.body);
          emails.add(EmailMessage.fromJson(emailData));
        } else {
          print(
              'Failed to fetch email details with status code: ${emailDetailsResponse.statusCode}');
        }
      }
      return emails;
    } else {
      print('Failed to fetch emails. Status code: ${response.statusCode}');
      print('Error response: ${response.body}');
      throw Exception(
          'Failed to fetch emails with status code: ${response.statusCode}');
    }
  }
}
