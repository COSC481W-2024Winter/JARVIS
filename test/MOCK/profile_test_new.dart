import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

void main() {
  group('ProfileScreenState', () {
    late MockFirebaseAuth auth;
    late FakeFirebaseFirestore firestore;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      auth = MockFirebaseAuth(mockUser: MockUser(uid: 'test'));
    });

    test('loads and saves profile data correctly', () async {
      final userData = {
        'fullName': 'Kevin',
        'age': '30',
        'story':
            'I am an online retailer on multiple sites selling a variety of items. Some of his sales happen automatically, while others require directly communicating with interested customers.',
      };

      final userDoc = firestore.collection('users').doc(auth as String);
      await userDoc.set(userData);

      // Act: Load the profile data
      final loadedData = await userDoc.get();

      // Assert: Check that the loaded profile data is correct
      expect(loadedData.data()?['fullName'], 'Kevin');
      expect(loadedData.data()?['age'], '30');
      expect(loadedData.data()?['story'],
          'I am an online retailer on multiple sites selling a variety of items. Some of his sales happen automatically, while others require directly communicating with interested customers.');

      // Act: Change and save the profile data
      final newUserData = {
        'fullName': 'Jimmy',
        'age': '37',
        'story':
            'I\'ve been a project manager for a mid-sized tech company for the past five years.',
      };
      await userDoc.set(newUserData);

      // Assert: Check that the saved profile data is correct
      final savedData = await userDoc.get();
      expect(savedData.data()?['fullName'], 'Jimmy');
      expect(savedData.data()?['age'], '37');
      expect(savedData.data()?['story'],
          'I\'ve been a project manager for a mid-sized tech company for the past five years.');
    });
  });
}
