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
              onPressed: () async {
                await accessSortCategorizeAndSummarizeEmails(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8FA5FD),
                padding: const EdgeInsets.all(20),
                shadowColor: Color.fromRGBO(255, 255, 255, 1),
                elevation: 7,
              ),
              child: const Text(
                'Access, Sort, Categorize, and Summarize Emails',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> accessSortCategorizeAndSummarizeEmails(
    BuildContext context) async {
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
  final businessKey = dotenv.env['CHATGPT_BUSINESS_KEY'];
  final arrangementKey = dotenv.env['CHATGPT_ARRANGEMENT_KEY'];
  final personalKey = dotenv.env['CHATGPT_PERSONAL_KEY'];
  final docEditKey = dotenv.env['CHATGPT_DOC_EDIT_KEY'];

  if (sorterApiKey == null ||
      businessKey == null ||
      arrangementKey == null ||
      personalKey == null ||
      docEditKey == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Required API tokens are not configured properly.")),
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
  final storageService = LocalStorageService();
  final chatGPTService = ChatGPTService(apiKeys: {
    'CHATGPT_BUSINESS_KEY': businessKey,
    'CHATGPT_ARRANGEMENT_KEY': arrangementKey,
    'CHATGPT_PERSONAL_KEY': personalKey,
    'CHATGPT_DOC_EDIT_KEY': docEditKey,
  });
  final emailSummarizer = EmailSummarizer(
    storageService: storageService,
    chatGPTService: chatGPTService,
  );

  try {
    final sortedEmails = await emailSortingRunner.sortEmails(accessToken, 10);
    final emailList = sortedEmails.map((email) {
      return {
        "Subject": email.subject,
        "Body": email.body,
      };
    }).toList();
    final categorizedEmails =
        await emailSortController.categorizeEmailsList(emailList);
    for (var email in categorizedEmails) {
      String categoryKey = 'emails_${email["Category"]}';
      List<Map<String, dynamic>> categoryList =
          (await storageService.getData(categoryKey))?['emails']
                  ?.cast<Map<String, dynamic>>() ??
              [];
      categoryList.add(email);
      await storageService.saveData(categoryKey, {'emails': categoryList});
    }

    final generatedSummaries = await emailSummarizer.summarizeEmails();
    await storageService.saveData('generatedSummaries', generatedSummaries);

    // Display the generated summaries to the user
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EmailSummariesScreen(summaries: generatedSummaries),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to process emails: $e")),
    );
  }
}
