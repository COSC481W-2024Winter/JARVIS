import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jarvis/backend/email_fetch_service.dart';
import 'package:jarvis/backend/email_gmail_signin_service.dart';
import 'package:jarvis/backend/email_sort_service.dart';
import 'package:jarvis/backend/email_sort_controller.dart';
import 'package:jarvis/backend/email_sorting_runner.dart';
import 'package:jarvis/backend/local_storage_service.dart';
import 'package:jarvis/backend/chatgpt_service.dart';
import 'package:jarvis/backend/email_summarizer.dart';
import 'package:jarvis/widgets/custom_toast_widget.dart';
import 'package:jarvis/backend/text_to_speech.dart';

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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Email Categorization'),
        centerTitle: true,
        backgroundColor: Color(0xFF8FA5FD),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed:
                  _isProcessing ? null : () => _showEmailCountDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8FA5FD),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                elevation: 7,
              ),
              child: const Text(
                'Generate Summaries',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showClearSummariesConfirmationDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                elevation: 5,
              ),
              child: Text(
                'Clear Summaries',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(height: 40),
            _buildCategoryButton(context, 'Company Business/Strategy',
                'emails_companyBusinessStrategy'),
            SizedBox(height: 20),
            _buildCategoryButton(context, 'Logistic Arrangements',
                'emails_logisticArrangements'),
            SizedBox(height: 20),
            _buildCategoryButton(
                context, 'Purely Personal', 'emails_purelyPersonal'),
            SizedBox(height: 20),
            _buildCategoryButton(
              context,
              'Document Editing/Checking/Collaboration',
              'emails_documentEditingCheckingCollaboration',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(
      BuildContext context, String label, String categoryKey) {
    final hasData = _categoriesWithData[categoryKey] ?? false;
    return ElevatedButton(
      onPressed: hasData ? () => _showSummary(context, categoryKey) : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: hasData ? Color(0xFF8FA5FD) : Colors.grey,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        elevation: 5,
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Map<String, bool> _categoriesWithData = {};
  Future<bool> _hasCategoryData(String categoryKey) async {
    final generatedSummaries =
        await storageService.getData('generatedSummaries');
    final hasData =
        generatedSummaries != null && generatedSummaries[categoryKey] != null;
    setState(() {
      _categoriesWithData[categoryKey] = hasData;
    });
    return hasData;
  }

  Future<bool> _hasSummaryData() async {
    final generatedSummaries =
        await storageService.getData('generatedSummaries');
    return generatedSummaries != null && generatedSummaries.isNotEmpty;
  }

  Future<void> _showClearSummariesConfirmationDialog(
      BuildContext context) async {
    final hasSummaryData = await _hasSummaryData();

    if (!hasSummaryData) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text(
              'Are you sure you want to clear summaries? The previous data will be lost.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _clearEmailCategoriesAndSummaries();
    }
  }

  Future<void> _showEmailCountDialog(BuildContext context) async {
    final hasSummaryData = await _hasSummaryData();

    if (hasSummaryData) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text(
                'Are you sure you want to generate new summaries? The previous data will be lost.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'),
              ),
            ],
          );
        },
      );

      if (confirmed != true) {
        return;
      }
    }

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

    OverlayEntry? toastEntry;
    String? currentToastMessage;

    void showProcessingToast(String message) {
      if (toastEntry == null || currentToastMessage != message) {
        currentToastMessage = message;
        toastEntry?.remove();
        toastEntry = OverlayEntry(
          builder: (context) => Positioned(
            bottom: 50,
            left: 50,
            right: 50,
            child: ToastWidget(message: message),
          ),
        );
        Overlay.of(context).insert(toastEntry!);
      }
    }

    void dismissToast() {
      toastEntry?.remove();
      toastEntry = null;
      currentToastMessage = null;
    }

    try {
      await _clearEmailCategoriesAndSummaries();
      showProcessingToast('Fetching emails...');
      final sortedEmails =
          await emailSortingRunner.sortEmails(accessToken, emailCount);
      final emailList = sortedEmails.map((email) {
        return {
          "Subject": email.subject,
          "Body": email.body,
        };
      }).toList();

      showProcessingToast('Categorizing emails...');
      final categorizedEmails =
          await emailSortController.categorizeEmailsList(emailList);

      await _saveEmailsToStorage(categorizedEmails);

      showProcessingToast('Generating summaries...');
      final generatedSummaries = await emailSummarizer.summarizeEmails();
      await storageService.saveData('generatedSummaries', generatedSummaries);

      // Update the _categoriesWithData map after generating summaries
      setState(() {
        generatedSummaries.forEach((category, _) {
          _categoriesWithData[category] = true;
        });
      });

      dismissToast();
      showToast(context, 'Summaries generated successfully!',
          duration: Duration(seconds: 5));
    } catch (e) {
      dismissToast();
      showToast(context, "Failed to process emails: $e",
          duration: Duration(seconds: 5));
    }
  }

  Future<void> _clearEmailCategoriesAndSummaries() async {
    final categories = [
      'emails_companyBusinessStrategy',
      'emails_logisticArrangements',
      'emails_purelyPersonal',
      'emails_documentEditingCheckingCollaboration',
    ];

    for (var category in categories) {
      await storageService.removeData(category);
    }

    await storageService.removeData('generatedSummaries');

    setState(() {
      _categoriesWithData.clear();
    });
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
    final tts = text_to_speech();
    bool isSpeaking = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Summary'),
              content: Text(summary),
              actions: [
                IconButton(
                  icon: Icon(isSpeaking ? Icons.stop : Icons.play_arrow),
                  onPressed: () async {
                    if (isSpeaking) {
                      await tts.stop();
                    } else {
                      await tts.speak(summary);
                    }
                    setState(() {
                      isSpeaking = !isSpeaking;
                    });
                  },
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
