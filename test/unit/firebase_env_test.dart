import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../lib/firebase_options.dart'; 

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DefaultFirebaseOptions Test without API keys', () {
    setUpAll(() async {
      await dotenv.load(fileName: ".env"); // Load the .env file（please place env file in the root directory of the project）
    });

    test('should load FirebaseOptions and match non-sensitive info for any platform', () async {
      //get the options for the current platform
      final options = await DefaultFirebaseOptions.currentPlatform;

      //check if the options are correct
      expect(options.projectId, dotenv.env['ANDROID_PROJECT_ID'] ?? dotenv.env['IOS_PROJECT_ID']);
      expect(options.storageBucket, dotenv.env['ANDROID_STORAGE_BUCKET'] ?? dotenv.env['IOS_STORAGE_BUCKET']);
    });
  });
}

