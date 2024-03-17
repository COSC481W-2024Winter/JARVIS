import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jarvis/backend/email_fetch_service.dart';
import 'package:jarvis/backend/email_gmail_signin_service.dart';
import 'package:jarvis/backend/email_sort_service.dart';
import 'package:jarvis/backend/email_sort_controller.dart';
import 'package:jarvis/backend/email_sorting_runner.dart';
import 'package:jarvis/backend/local_storage_service.dart';
import 'package:jarvis/backend/chatgpt_service.dart';
import 'package:jarvis/backend/email_summarizer.dart';
import 'package:jarvis/emails_screen.dart';
import 'package:jarvis/emails_summaries_screen.dart';


class EmailCategorizationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Email Categorization and Summarization')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Access and Sort Emails'),
              onPressed: () async {
                await _accessAndSortEmails(context);
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Categorize and Summarize Emails'),
              onPressed: () async {
                await categorizeAndSummarizeEmails(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _accessAndSortEmails(BuildContext context) async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No user logged in.")),
    );
    return;
  }

  final GoogleSignInService googleSignInService = GoogleSignInService();
  final String? accessToken = await googleSignInService.signInWithGoogle();

  if (accessToken == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to retrieve access token.")),
    );
    return;
  }

  final sorterApiKey = dotenv.env['SORTER_KEY'];

  if (sorterApiKey == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Required API tokens are not configured properly.")),
    );
    return;
  }

  final emailFetchingService = EmailFetchingService();
  final emailSorter = EmailSorter(apiToken: sorterApiKey);
  final emailSortController = EmailSortController(emailSorter: emailSorter);
  final emailSortingRunner = EmailSortingRunner(
    emailFetchingService: emailFetchingService,
    emailSortController: emailSortController,
  );

  try {
    final sortedEmails = await emailSortingRunner.sortEmails(accessToken, 10);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmailsScreen(emails: sortedEmails)),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to access emails: $e")),
    );
  }
}

Future<void> categorizeAndSummarizeEmails(BuildContext context) async {
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
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("One or more required API keys not found in .env file")));
    return;
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

  // Display the generated summaries to the user
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EmailSummariesScreen(summaries: generatedSummaries),
    ),
  );
}
