import 'package:google_sign_in/google_sign_in.dart';

class SignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/gmail.readonly',
    ],
  );

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
}
