import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jarvis/backend/email_sort_service.dart';
import 'package:jarvis/backend/email_sort_controller.dart';
import 'package:jarvis/backend/local_storage_service.dart';
import 'package:jarvis/backend/chatgpt_service.dart';
import 'package:jarvis/backend/email_summarizer.dart';

class EmailCategorizationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Email Categorization and Summarization')),
      body: Center(
        child: ElevatedButton(
          child: Text('Start Process'),
          onPressed: () async {
            await categorizeAndSummarizeEmails();
          },
        ),
      ),
    );
  }
}

Future<void> categorizeAndSummarizeEmails() async {
  final sorterToken = dotenv.env['SORTER_KEY'];
  final businessKey = dotenv.env['CHATGPT_BUSINESS_KEY'];
  final arrangementKey = dotenv.env['CHATGPT_ARRANGEMENT_KEY'];
  final personalKey = dotenv.env['CHATGPT_PERSONAL_KEY'];
  final docEditKey = dotenv.env['CHATGPT_DOC_EDIT_KEY'];

  if (sorterToken == null ||
      businessKey == null ||
      arrangementKey == null ||
      personalKey == null ||
      docEditKey == null) {
    throw Exception('One or more required API keys not found in .env file');
  }

  EmailSorter emailSorter = EmailSorter(apiToken: sorterToken);
  EmailSortController emailSortController =
      EmailSortController(emailSorter: emailSorter);
  LocalStorageService storageService = LocalStorageService();
  ChatGPTService chatGPTService = ChatGPTService(apiKeys: {
    'CHATGPT_BUSINESS_KEY': businessKey,
    'CHATGPT_ARRANGEMENT_KEY': arrangementKey,
    'CHATGPT_PERSONAL_KEY': personalKey,
    'CHATGPT_DOC_EDIT_KEY': docEditKey,
  });
  EmailSummarizer emailSummarizer = EmailSummarizer(
    storageService: storageService,
    chatGPTService: chatGPTService,
  );

  var jsonString =
      await rootBundle.loadString('assets/data/uncategorized_emails_10.json');
  List<dynamic> emailList = json.decode(jsonString);

  List<Map<String, String>> emails = emailList.map((email) {
    return {
      "Subject": email["Subject"] as String,
      "Body": email["Body"] as String,
    };
  }).toList();

  List<Map<String, dynamic>> categorizedEmails =
      await emailSortController.categorizeEmailsList(emails);

  for (var email in categorizedEmails) {
    String categoryKey = 'emails_${email["Category"]}';
    List<Map<String, dynamic>> categoryList =
        (await storageService.getData(categoryKey))?['emails']
                ?.cast<Map<String, dynamic>>() ??
            [];
    categoryList.add(email);
    await storageService.saveData(categoryKey, {'emails': categoryList});
  }

  Map<String, String> generatedSummaries =
      await emailSummarizer.summarizeEmails();
  await storageService.saveData('generatedSummaries', generatedSummaries);
}
