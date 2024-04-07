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
        foregroundColor: Theme.of(context).colorScheme.background, backgroundColor: Theme.of(context).colorScheme.primary, fixedSize: const Size(300, 60), // Text Color (Foreground color)
        shadowColor: Theme.of(context).colorScheme.shadow,
        elevation: 7,
      ),
      child: Text(
        label,
        style:  TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}
