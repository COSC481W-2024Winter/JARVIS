import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis/backend/local_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // Ensure the Flutter test environment is initialized

  group('LocalStorageService Tests', () {
    late LocalStorageService storageService;

    setUp(() async {
      // Initialize the LocalStorageService before each test
      storageService = LocalStorageService();
      // If necessary, initialize Localstore or set up a mock version here
    });

    test('write and read JSON', () async {
      // Define test data
      final testData = {'name': 'Test Name', 'age': 25};

      // Write data
      await storageService.writeJson(testData);

      // Read data back
      final resultData = await storageService.readJson();

      // Verify the data is the same
      expect(resultData, equals(testData));
    });

    // Add more tests as needed
  });
}