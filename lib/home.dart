import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:jarvis/setting.dart';
import 'backend/email_gmail_signin_service.dart'; // Ensure this import is correct
import 'emails_screen.dart'; // Ensure you have this file and import it
// import 'email_service.dart'; // Ensure this file exists and import it
import 'main.dart'; // Assuming you have a HomePage widget. Make sure this import is correct
import 'package:speech_to_text/speech_to_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SpeechToText speechToText = SpeechToText();
  String _wordsSpoken = "";

  void _startListening() async {
    bool available = await speechToText.initialize();
    if (available) {
      await speechToText.listen(onResult: _onSpeechResult);
    } else {
      print("The user has denied the use of speech recognition.");
      // Handle the case where speech recognition is not available or not permitted
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ProfileScreen>(
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(
                      title: const Text('User Profile'),
                    ),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.of(context).pop();
                      })
                    ],
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Redirect to Setting page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Setting()),
              );
            },
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final accessToken = await signInWithGoogle(); // Make sure this returns a token
                final response = await fetchEmails(accessToken!); // This should be modified to return a list of EmailMessage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmailsScreen(emails: response)),
                );
              } catch (e) {
                // Handle errors or no emails found
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to access emails: $e")),
                );
              }
            },
            child: const Text('Access Email'),
          ),
          ElevatedButton(
            onPressed: () {
              // Redirect to HomePage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()), // Update this with correct HomePage navigation if necessary
              );
            },
            child: const Text('Listen Email'),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // This aligns the column's children vertically in the center.
          children: [
            Text(
              'Welcome!',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 20), // Adds a vertical space between the text and the button
            IconButton(
              icon: Icon(
                speechToText.isListening ? Icons.mic : Icons.mic_none,
                size: 50.0,
                color: Colors.blue,
              ),
              onPressed: speechToText.isListening ? _stopListening : _startListening,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _wordsSpoken,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
