import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:jarvis/profile_screen_jarvis.dart';
import 'package:jarvis/email_categorization_screen.dart';
import 'package:jarvis/backend/email_gmail_signin_service.dart';
import 'package:jarvis/email_summary.dart';
import 'package:jarvis/main.dart';
import 'package:jarvis/setting.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:jarvis/backend/text_to_gpt_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleSignInService signInService = GoogleSignInService();
  final SpeechToText speechToText = SpeechToText();
  String _wordsSpoken = "";
  String _gptResponse = "";

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
        _buildListenEmailButton(context),
        _buildCategorizationButton(context),
      ],
      automaticallyImplyLeading: false,
    );
  }

  ElevatedButton _buildCategorizationButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _navigateToCategorizationScreen(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8FA5FD),
        padding: const EdgeInsets.all(20),
        shadowColor: Colors.blueGrey,
        elevation: 1,
      ),
      child: const Text(
        'Categorize Emails',
        style: TextStyle(color: Colors.white, fontSize: 12.0),
      ),
    );
  }

  void _navigateToCategorizationScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmailCategorizationScreen()),
    );
    setState(
        () {}); // Refresh the UI after returning from EmailCategorizationScreen
  }

  IconButton _buildProfileButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.person, color: const Color(0xFF8FA5FD)),
      onPressed: () => _navigateToProfileScreen(context),
    );
  }

  IconButton _buildSettingsButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings, color: const Color(0xFF8FA5FD)),
      onPressed: () => _navigateToSettings(context),
    );
  }

  ElevatedButton _buildListenEmailButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _navigateToHomePage(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8FA5FD),
        padding: const EdgeInsets.all(20),
        shadowColor: Colors.blueGrey,
        elevation: 1,
      ),
      child: const Text(
        'Sample',
        style: TextStyle(color: Colors.white, fontSize: 12.0),
      ),
    );
  }

  ElevatedButton _buildEmailSumButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _navigateToEmailSumButtonsScreen(context),
      style: ElevatedButton.styleFrom(
        //shape: const CircleBorder(),
        backgroundColor: const Color(0xFF8FA5FD),
        padding: const EdgeInsets.all(20),
        shadowColor: Colors.blueGrey,
        elevation: 10,
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Email Summaries',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 24.0)),
          Icon(
            Icons.mail,
            size: 30.0,
            color: Colors.white,
          ),
          SizedBox(width: 8),
        ],
      ),
    );
  }

  Center _buildBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Welcome!', style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 20),
          _buildMicrophoneButton(),
          _buildTranscriptionText(),
          _buildEmailSumButton(context),
        ],
      ),
    );
  }

  IconButton _buildMicrophoneButton() {
    return IconButton(
      icon: Icon(speechToText.isListening ? Icons.mic : Icons.mic_none,
          size: 50.0, color: const Color(0xFF8FA5FD)),
      onPressed: speechToText.isListening ? _stopListening : _startListening,
    );
  }

  Padding _buildTranscriptionText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _wordsSpoken,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 8.0),
          Text(
            _gptResponse,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  void _startListening() async {
    bool available = await speechToText.initialize();
    if (available) {
      await speechToText.listen(onResult: _onSpeechResult);
    } else {
      print("The user has denied the use of speech recognition.");
    }
    setState(() {});
  }

  void _stopListening() async {
    await speechToText.stop();
    Future.delayed(Duration(milliseconds: 200), () {
      processing();
    });
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = result.recognizedWords;
    });

    if (speechToText.isNotListening) {
      Future.delayed(Duration(milliseconds: 200), () {
        processing();
      });
    }
  }

  void processing() async {
    String generatedText =
        await text_to_gpt_service().send_to_GPT(_wordsSpoken, "talk");
    setState(() {
      _gptResponse = generatedText;
      _wordsSpoken = "";
    });

    //text_to_speech().speak(generatedText);
  }

  void _navigateToProfileScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<ProfileScreenJarvis>(
        builder: (context) => ProfileScreenJarvis(
          appBar: AppBar(title: const Text('User Profile')),
          actions: [SignedOutAction((context) => Navigator.of(context).pop())],
        ),
      ),
    );
  }

  void _navigateToEmailSumButtonsScreen(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const EmailSum()));
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Setting()));
  }

  void _navigateToHomePage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  }
}
