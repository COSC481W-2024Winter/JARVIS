import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON decoding
import 'email_service.dart'; // Make sure this import points to your EmailMessage model

// Google Sign-In configuration
GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/gmail.readonly',
  ],
);

// Function to handle Google Sign-In and return access token
Future<String?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await account!.authentication;
    return googleAuth.accessToken; // Return the access token
  } catch (error) {
    print('Error signing in with Google: $error');
    return null; // Return null in case of error
  }
}

// Function to fetch emails using Gmail API and return a list of EmailMessage
Future<List<EmailMessage>> fetchEmails(String accessToken) async {
  final url = Uri.parse('https://www.googleapis.com/gmail/v1/users/me/messages');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer $accessToken',
  });

  if (response.statusCode == 200) {
    // Parse the JSON data
    final data = json.decode(response.body);
    // Convert the data to a list of EmailMessage objects
    List<EmailMessage> emails = [];
    for (var message in data['messages']) {
      emails.add(EmailMessage.fromJson(message));
    }
    return emails; // Return the list of emails
  } else {
    throw Exception('Failed to fetch emails with status code: ${response.statusCode}');
  }
}
