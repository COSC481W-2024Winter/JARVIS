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

  testWidgets('ToastWidget respects duration', (WidgetTester tester) async {
    const testMessage = 'Test Message';
    const testDuration = Duration(seconds: 3);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ToastWidget(message: testMessage, duration: testDuration),
      ),
    ));

    // Initially, we should find the widget
    expect(find.byType(ToastWidget), findsOneWidget);

    // After the duration, it should be gone
    await tester.pumpAndSettle(testDuration);
    expect(find.byType(ToastWidget), findsNothing);
  });
}
