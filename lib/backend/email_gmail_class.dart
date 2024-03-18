import 'dart:convert';

List<EmailMessage> parseEmails(String responseBody) {
  final parsed = json.decode(responseBody);
  return parsed['messages']
      .map<EmailMessage>((json) => EmailMessage.fromJson(json))
      .toList();
}

class EmailMessage {
  final String id;
  final String subject;
  final String body; // Plain text or HTML
  final String category;

  EmailMessage({
    required this.id,
    required this.subject,
    required this.body,
    required this.category,
  });

  factory EmailMessage.fromJson(Map<String, dynamic> json) {
    // Initialize subject and body with default values
    String subject = 'No Subject';
    String body = 'No Content';

    // Check if headers exist and extract subject
    var headers = json['payload']?['headers'];
    if (headers != null) {
      final subjectHeader = headers.firstWhere(
        (header) => header['name'] == 'Subject',
        orElse: () => {'value': subject}, // Use default 'No Subject'
      );
      subject = subjectHeader['value'];
    }

    // Check if body exists and extract body content
    var bodySize = json['payload']?['body']?['size'];
    if (bodySize != null && bodySize > 0) {
      body = utf8.decode(base64Url.decode(json['payload']['body']['data']));
    } else if (json['payload']?.containsKey('parts') == true) {
      for (var part in json['payload']['parts']) {
        if (part['mimeType'] == 'text/plain' && part['body']['size'] > 0) {
          body = utf8.decode(base64Url.decode(part['body']['data']));
          break;
        }
      }
    }

    return EmailMessage(
        id: json['id'], subject: subject, body: body, category: '');
  }
}
