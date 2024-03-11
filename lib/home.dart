import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:jarvis/backend/email_fetch_service.dart';
import 'package:jarvis/backend/email_gmail_signin_service.dart';
import 'package:jarvis/backend/email_sort_service.dart';
import 'package:jarvis/backend/email_sorting_runner.dart';
import 'package:jarvis/emails_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jarvis/main.dart';
import 'package:jarvis/setting.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleSignInService signInService = GoogleSignInService();
  final SpeechToText speechToText = SpeechToText();
  String _wordsSpoken = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        _buildProfileButton(context),
        _buildSettingsButton(context),
        _buildAccessEmailButton(context),
        _buildListenEmailButton(context),
      ],
      automaticallyImplyLeading: false,
    );
  }

  IconButton _buildProfileButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.person),
      onPressed: () => _navigateToProfileScreen(context),
    );
  }

  IconButton _buildSettingsButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () => _navigateToSettings(context),
    );
  }

  ElevatedButton _buildAccessEmailButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _accessAndSortEmails(),
      child: const Text('Access and Sort Emails'),
    );
  }

  ElevatedButton _buildListenEmailButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _navigateToHomePage(context),
      child: const Text('Listen Email'),
    );
  }

  Center _buildBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Welcome!', style: Theme.of(context).textTheme.headline4),
          const SizedBox(height: 20),
          _buildMicrophoneButton(),
          _buildTranscriptionText(),
        ],
      ),
    );
  }

  IconButton _buildMicrophoneButton() {
    return IconButton(
      icon: Icon(
        speechToText.isListening ? Icons.mic : Icons.mic_none,
        size: 50.0,
        color: Colors.blue,
      ),
      onPressed: speechToText.isListening ? _stopListening : _startListening,
    );
  }

  Padding _buildTranscriptionText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        _wordsSpoken,
        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
      ),
    );
  }

  void _accessAndSortEmails() async {
    // Ensure you load your environment variables where you have your API token stored
    final accessToken = dotenv.env['JARVISTEST684_EMAIL_TEMP'];
    final sorterApiKey = dotenv.env['SORTER_KEY'];

    if (accessToken == null || sorterApiKey == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Required API tokens are not configured properly.")));
      return;
    }

    final emailFetchingService = EmailFetchingService();
    final emailSorter = EmailSorter(apiToken: sorterApiKey);
    final emailSortingRunner = EmailSortingRunner(
      emailFetchingService: emailFetchingService,
      emailSorter: emailSorter,
    );

    try {
      final sortedEmails = await emailSortingRunner.sortEmails(accessToken, 10);
      Navigator.push(context, MaterialPageRoute(builder: (context) => EmailsScreen(emails: sortedEmails)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to access emails: $e")));
    }
  }

  void _startListening() async {
    bool available = await speechToText.initialize();
    if (available) {
      await speechToText.listen(onResult: _onSpeechResult);
    } else {
      print("The user has denied the use of speech recognition.");
    }
  }

  void _navigateToHomePage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
  }

  void _stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = result.recognizedWords;
    });
  }

  void _navigateToProfileScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<ProfileScreen>(
        builder: (context) => ProfileScreen(
          appBar: AppBar(title: const Text('User Profile')),
          actions: [SignedOutAction((context) => Navigator.of(context).pop())],
        ),
      ),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Setting()));
  }
}
