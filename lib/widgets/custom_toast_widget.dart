import 'package:flutter/material.dart';

class ToastWidget extends StatelessWidget {
  final String message;
  final Duration duration;

  const ToastWidget({
    Key? key,
    required this.message,
    this.duration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Theme.of(context).colorScheme.tertiary,
      ),
      child: Text(
        message,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 16.0, // Adjust the font size here
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}

void showToast(BuildContext context, String message,
    {Duration duration = const Duration(seconds: 5)}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: ToastWidget(message: message, duration: duration),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}
