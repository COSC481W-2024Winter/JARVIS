import 'package:flutter/material.dart';

class CustomSubmitButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomSubmitButton(
      {Key? key, required this.label, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.blue, fixedSize: const Size(400, 60), // Text Color (Foreground color)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
