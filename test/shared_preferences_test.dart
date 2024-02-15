import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  String fullNameKey = "name";
  String ageKey = "age";
  String storyKey = "story";

  test('shared prefs test', () async {
    SharedPreferences.setMockInitialValues({
      fullNameKey: 'John Doe',
      ageKey: '30',
      storyKey: 'My story',
    });

    final prefs = await SharedPreferences.getInstance();

    final fullName = prefs.getString(fullNameKey);
    final age = prefs.getString(ageKey);
    final story = prefs.getString(storyKey);

    print(fullName);
    print(age);
    print(story);

    expect(fullName, 'John Doe');
    expect(age, '30');
    expect(story, 'My story');
  });
}
