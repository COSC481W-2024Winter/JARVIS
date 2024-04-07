import 'package:flutter/material.dart';

class CustomSubmitButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomSubmitButton(
      {super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.background, backgroundColor: Theme.of(context).colorScheme.primary, fixedSize: const Size(400, 60), // Text Color (Foreground color)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        shadowColor: Theme.of(context).colorScheme.shadow,
        elevation: 10,
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}
