import 'dart:convert';

List<EmailMessage> parseEmails(String responseBody) {
  final parsed = json.decode(responseBody);
  return parsed['messages']
      .map<EmailMessage>((json) => EmailMessage.fromJson(json))
      .toList();
}

class EmailMessage {
  final String id;
  final String threadId;

  EmailMessage({required this.id, required this.threadId});

  factory EmailMessage.fromJson(Map<String, dynamic> json) {
    return EmailMessage(
      id: json['id'] as String,
      threadId: json['threadId'] as String,
    );
  }
}
