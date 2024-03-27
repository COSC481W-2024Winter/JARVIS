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

class EmailCategorizationScreen extends StatefulWidget {
  @override
  _EmailCategorizationScreenState createState() =>
      _EmailCategorizationScreenState();
}

class _EmailCategorizationScreenState extends State<EmailCategorizationScreen> {
  bool _isProcessing = false;
  final emailFetchingService = EmailFetchingService();
  late final emailSorter =
      EmailSorter(apiToken: dotenv.env['SORTER_KEY'] ?? '');
  late final emailSortController =
      EmailSortController(emailSorter: emailSorter);
  late final emailSortingRunner = EmailSortingRunner(
    emailFetchingService: emailFetchingService,
    emailSortController: emailSortController,
  );
  final storageService = LocalStorageService();
  final chatGPTService = ChatGPTService(apiKeys: {
    'CHATGPT_BUSINESS_KEY': dotenv.env['CHATGPT_BUSINESS_KEY'] ?? '',
    'CHATGPT_ARRANGEMENT_KEY': dotenv.env['CHATGPT_ARRANGEMENT_KEY'] ?? '',
    'CHATGPT_PERSONAL_KEY': dotenv.env['CHATGPT_PERSONAL_KEY'] ?? '',
    'CHATGPT_DOC_EDIT_KEY': dotenv.env['CHATGPT_DOC_EDIT_KEY'] ?? '',
  });
  late final emailSummarizer = EmailSummarizer(
    storageService: storageService,
    chatGPTService: chatGPTService,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Email Categorization and Summarization')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed:
                  _isProcessing ? null : () => _showEmailCountDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8FA5FD),
                padding: const EdgeInsets.all(20),
                shadowColor: Color.fromRGBO(255, 255, 255, 1),
                elevation: 7,
              ),
              child: const Text(
                'Generate Summaries',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            _buildCategoryButton(context, 'Company Business/Strategy',
                'emails_companyBusinessStrategy'),
            _buildCategoryButton(context, 'Logistic Arrangements',
                'emails_logisticArrangements'),
            _buildCategoryButton(
                context, 'Purely Personal', 'emails_purelyPersonal'),
            _buildCategoryButton(
                context,
                'Document editing/checking/collaboration',
                'emails_documentEditingCheckingCollaboration'),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(
      BuildContext context, String label, String categoryKey) {
    return FutureBuilder<bool>(
      future: _hasCategoryData(categoryKey),
      builder: (context, snapshot) {
        final hasData = snapshot.data ?? false;
        return ElevatedButton(
          onPressed: hasData ? () => _showSummary(context, categoryKey) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: hasData ? Colors.blue : Colors.grey,
            padding: const EdgeInsets.all(10),
          ),
          child: Text(label),
        );
      },
    );
  }

  Future<bool> _hasCategoryData(String categoryKey) async {
    final generatedSummaries =
        await storageService.getData('generatedSummaries');
    return generatedSummaries != null &&
        generatedSummaries[categoryKey] != null;
  }

  Future<void> _showEmailCountDialog(BuildContext context) async {
    final emailCount = await showDialog<int>(
      context: context,
      builder: (context) {
        String value = '';
        return AlertDialog(
          title: Text('Enter the number of emails to fetch'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (v) => value = v,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(int.tryParse(value)),
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    if (emailCount != null && emailCount > 0) {
      setState(() {
        _isProcessing = true;
      });
      await _processEmails(context, emailCount);
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _processEmails(BuildContext context, int emailCount) async {
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

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fetching emails...')),
      );
      final sortedEmails =
          await emailSortingRunner.sortEmails(accessToken, emailCount);
      final emailList = sortedEmails.map((email) {
        return {
          "Subject": email.subject,
          "Body": email.body,
        };
      }).toList();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Categorizing emails...')),
      );
      final categorizedEmails =
          await emailSortController.categorizeEmailsList(emailList);
      await _saveEmailsToStorage(categorizedEmails);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Generating summaries...')),
      );
      final generatedSummaries = await emailSummarizer.summarizeEmails();
      await storageService.saveData('generatedSummaries', generatedSummaries);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Summaries generated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to process emails: $e")),
      );
    }
  }

  Future<void> _saveEmailsToStorage(
      List<Map<String, dynamic>> categorizedEmails) async {
    for (var email in categorizedEmails) {
      String categoryKey = 'emails_${email["Category"]}';
      List<Map<String, dynamic>> categoryList =
          (await storageService.getData(categoryKey))?['emails']
                  ?.cast<Map<String, dynamic>>() ??
              [];
      categoryList.add(email);
      await storageService.saveData(categoryKey, {'emails': categoryList});
    }
  }

  Future<void> _showSummary(BuildContext context, String categoryKey) async {
    if (_isProcessing) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please be patient. Processing in progress.')),
      );
      return;
    }

    final generatedSummaries =
        await storageService.getData('generatedSummaries');

    if (generatedSummaries == null || generatedSummaries[categoryKey] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No data available. Generate summaries first.')),
      );
      return;
    }

    final summary = generatedSummaries[categoryKey];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Summary'),
          content: Text(summary),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
