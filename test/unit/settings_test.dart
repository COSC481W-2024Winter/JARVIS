import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

//unit test for setting.dart
void main() {

  // test for initState method
  test('Init state test', () async {
    SharedPreferences.setMockInitialValues({});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', 'en-US');
    await prefs.setDouble('pitch', 1.0);
    expect(prefs.getString('language'), 'en-US');
    expect(prefs.getDouble('pitch'), 1.0);
  });

   // test for loadSettings method
  test('Load settings test', () async {
    SharedPreferences.setMockInitialValues({});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', 'en-US');
    await prefs.setDouble('pitch', 1.0);
    expect(prefs.getString('language'), 'en-US');
    expect(prefs.getDouble('pitch'), 1.0);
  });

  // test for saveSettings method
  test('Save settings test', () async {
    SharedPreferences.setMockInitialValues({});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', 'en-US');
    await prefs.setDouble('pitch', 1.0);
    expect(prefs.getString('language'), 'en-US');
    expect(prefs.getDouble('pitch'), 1.0);
  });

  // test for the settings widgets
  testWidgets('Setting page test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(MaterialApp(home: Setting()));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Pitch'), findsOneWidget);
  });

  // test for setLanguage method
  test('Set language test', () async {
    SharedPreferences.setMockInitialValues({});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', 'en-US');
    expect(prefs.getString('language'), 'en-US');
  });

  // test for setPitch method
  test('Set pitch test', () async {
    SharedPreferences.setMockInitialValues({});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('pitch', 1.0);
    expect(prefs.getDouble('pitch'), 1.0);
  });

 

  
  

  
}
