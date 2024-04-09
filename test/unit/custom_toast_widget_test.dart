import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis/widgets/custom_toast_widget.dart';

void main() {
  testWidgets('ToastWidget displays the message', (WidgetTester tester) async {
    const testMessage = 'Test Message';
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ToastWidget(message: testMessage),
      ),
    ));

    // Check if the widget is displaying the message
    expect(find.text(testMessage), findsOneWidget);
  });

testWidgets('showToast respects duration', (WidgetTester tester) async {
  const testMessage = 'Test Message';
  const testDuration = Duration(seconds: 3);

  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              showToast(context, testMessage, duration: testDuration);
            },
            child: const Text('Show Toast'),
          );
        },
      ),
    ),
  ));

  // Initially, the ToastWidget should not be present
  expect(find.byType(ToastWidget), findsNothing);

  // Tap the button to show the toast
  await tester.tap(find.text('Show Toast'));
  await tester.pumpAndSettle();

  // After tapping, the ToastWidget should be present
  expect(find.byType(ToastWidget), findsOneWidget);

  // Wait for the toast duration
  await tester.pumpAndSettle(testDuration);

  // After the duration, the ToastWidget should be gone
  expect(find.byType(ToastWidget), findsNothing);
});
}