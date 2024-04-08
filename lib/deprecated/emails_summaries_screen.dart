import 'package:flutter/material.dart';

class EmailSummariesScreen extends StatelessWidget {
  final Map<String, String> summaries;

  const EmailSummariesScreen({Key? key, required this.summaries})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Email Summaries')),
      body: ListView.builder(
        itemCount: summaries.length,
        itemBuilder: (context, index) {
          String category = summaries.keys.elementAt(index);
          String summary = summaries[category]!;
          return ListTile(
            title: Text(category),
            subtitle: Text(summary),
          );
        },
      ),
    );
  }
}
