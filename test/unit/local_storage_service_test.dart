import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis/backend/local_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalStorageService', () {
    late LocalStorageService storageService;

    setUp(() async {
      storageService = LocalStorageService();
    });

      test('saveData and getData should work correctly', () async {
      // Sample JSON data
      final jsonData = [
        {
          "Subject": "RE: NERC Statements on Impact of Security Threats on RTOs",
          "Body": "I agree with Joe. The IOUs will point to NERC as an objective third party on these issues. ",
          "Category": "Company Business/Strategy"
        },
        {
          "Subject": "RE: NERC Meeting Today",
          "Body": "There was an all day meeting of the NERC/reliability legislation group today. I will provide a more detailed report but the group completed the process of reviewing the changes that some had suggested to shorten and streamline the NERC electric reliability organization legislation. Sarah and I asked a series of questions and made comments on our key issues and concerns. I want to give you a more complete report once I have gone back over the now final draft version. The timing being imposed by NERC is that they will circulate a clean version of the proposal tomorrow or Monday. They have asked for comments by next Thursday August 16th with an indication of whether each company/organization does or does not sign on to support it. They will then transmit the proposal and the endorsement letter to Congress and the Administration so they have it as Hill and Energy Dept. staff work on electricity drafting issues this month. I pointed out that EPSA is not due to meet internally with its members to discuss these issues until after the NERC deadline. That is not deterring NERC from moving forward with the above time frame.",
          "Category": "Company Business/Strategy"
        },
        // ... Add more JSON objects from your data
      ];

      // Convert List<Map<String, String>> to Map<String, dynamic>
      final jsonMap = {'emails': jsonData};

      // Save the JSON data
      await storageService.saveData('emails', jsonMap);

      // Retrieve the saved data
      final savedData = await storageService.getData('emails');

      // Verify the retrieved data matches the original data
      expect(savedData, equals(jsonMap));
    });
  });
}