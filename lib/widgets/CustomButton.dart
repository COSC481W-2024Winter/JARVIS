import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: const Color(0xFF8FA5FD), fixedSize: const Size(400, 60), // Text Color (Foreground color)
        shadowColor: Colors.blueGrey,
        elevation: 10,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
