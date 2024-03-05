import 'package:flutter/material.dart';

import 'backend/email_gmail_class.dart';

class EmailsScreen extends StatelessWidget {
  final List<EmailMessage> emails;

  const EmailsScreen({super.key, required this.emails});

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
            title: Text('Email ID: ${emails[index].id}'),
            subtitle: Text('Thread ID: ${emails[index].threadId}'),
          );
        },
      ),
    );
  }
}
