import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:jarvis/volumecontrollerscreen.dart'; // Import your MyApp widget

class MockVolumeController extends Mock implements VolumeController {}

void main() {

  testWidgets('Check if all buttons exist on page', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MyAppp()));

    // Verify that the volume slider exists
    expect(find.byType(Slider), findsOneWidget);

    // Verify that mute button exists
    expect(find.text('Mute'), findsOneWidget);

    // Verify that go back button exists
    expect(find.text('Go Back'), findsOneWidget);

  });

   testWidgets('Volume Slider should say 0.0', (WidgetTester tester) async {
    // Create a mock volume controller
    final volumeController = MockVolumeController();

    // Stub the setVolume method to do nothing
    when(volumeController.setVolume(0.0)).thenReturn(null);

    // Build the widget tree
    await tester.pumpWidget(MaterialApp(home: MyAppp()));

    // Check that the 'go back' button does something
    await tester.tap(find.text('Go Back'));
    await tester.pump();

    // Check that the 'mute' button does something
    await tester.tap(find.text('Mute'));
    await tester.pump();

  });

  
}
