import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:jarvis/setting.dart';
import 'google_sign_in_service.dart'; // Ensure this import is correct
import 'emails_screen.dart'; // Ensure you have this file and import it
// import 'email_service.dart'; // Ensure this file exists and import it
import 'main.dart'; // Assuming you have a HomePage widget. Make sure this import is correct

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
          children: [
            Text(
              'Welcome!',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SignOutButton(),
          ],
        ),
      ),
    );
  }
}
