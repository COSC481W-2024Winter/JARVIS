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
      child: Text(
        label,
        style: TextStyle(fontSize: 20),
      ),
      style: ElevatedButton.styleFrom(
        fixedSize: Size(400, 60),
        primary: Colors.blue, // Background color
        onPrimary: Colors.white, // Text Color (Foreground color)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
