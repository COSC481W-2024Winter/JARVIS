import 'package:flutter/material.dart';
import 'package:jarvis/backend/email_gmail_class.dart';

class EmailsScreen extends StatelessWidget {
  final List<EmailMessage> emails;

  const EmailsScreen({Key? key, required this.emails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emails'),
      ),
      body: ListView.builder(
        itemCount: emails.length,
        itemBuilder: (context, index) {
          return ListTile(
            //title: Text('Email ID: ${emails[index].id}'),
            //subtitle: Text('Thread ID: ${emails[index].threadId}'),
            title: Text(emails[index].subject), // Display subject
            subtitle: Text(emails[index].body), // Display body snippet or full body
          );
        },
      ),
    );
  }
}
