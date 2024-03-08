import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:jarvis/setting.dart';
import 'google_sign_in_service.dart'; // Adjusted for updated sign-in and fetching
import 'emails_screen.dart'; // Updated for displaying subject and body
import 'main.dart'; // Ensure correct import

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleSignInService signInService = GoogleSignInService(); // Assuming signInService is updated for new requirements

  void _accessEmail() async {
    try {
      final accessToken = await signInService.signInWithGoogle();
      if (accessToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to sign in with Google")));
        return;
      }

      final emails = await signInService.fetchEmails(accessToken);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EmailsScreen(emails: emails)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to access emails: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Setting())),
          ),
          ElevatedButton(
            onPressed: _accessEmail,
            child: const Text('Access Email'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage())),
            child: const Text('Listen Email'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text('Welcome!', style: Theme.of(context).textTheme.displaySmall),
            const SignOutButton(),
          ],
        ),
      ),
    );
  }
}
