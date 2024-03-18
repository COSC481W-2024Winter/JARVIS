import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jarvis/backend/email_gmail_class.dart'; // For JSON decoding

// Google Sign-In configuration
class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/gmail.readonly',
    ],
  );

  // Function to handle Google Sign-In and return access token
  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        final GoogleSignInAuthentication googleAuth =
            await account.authentication;
        return googleAuth.accessToken; // Return the access token
      }
      return null; // Return null if account is null
    } catch (error) {
      print('Error signing in with Google: $error');
      return null; // Return null in case of error
    }
  }

  //Function to fetch emails using Gmail API and return a list of EmailMessage
  Future<List<EmailMessage>> fetchEmails(String accessToken) async {
    List<EmailMessage> emails = [];
    // Fetch list of emails (IDs)
    final listUrl = Uri.parse(
        'https://www.googleapis.com/gmail/v1/users/me/messages?maxResults=10');
    final listResponse = await http
        .get(listUrl, headers: {'Authorization': 'Bearer $accessToken'});
    if (listResponse.statusCode == 200) {
      final listData = json.decode(listResponse.body);
      for (var messageSummary in listData['messages']) {
        // Fetch details for each email by ID to get subject and body
        final detailUrl = Uri.parse(
            'https://www.googleapis.com/gmail/v1/users/me/messages/${messageSummary['id']}');
        final detailResponse = await http
            .get(detailUrl, headers: {'Authorization': 'Bearer $accessToken'});
        if (detailResponse.statusCode == 200) {
          final detailData = json.decode(detailResponse.body);

          // Debug print statement here
          print(
              jsonEncode(detailData['payload'])); // Debug the payload structure

          emails.add(EmailMessage.fromJson(detailData));
        }
      }
    }
    return emails;
  }
}
