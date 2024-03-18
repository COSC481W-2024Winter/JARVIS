import 'package:flutter/material.dart';
import 'widgets/CustomHeader.dart';
import 'auth_gate.dart';

class Arrangements extends StatelessWidget {
  const Arrangements({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Arrangements',
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // Log out button
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0), // Space from bottom
            child: ElevatedButton(
              onPressed: () {
                //Go to welcome screen screen.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthGate()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100), // Rounded shape
                ),
                minimumSize:
                    const Size(double.infinity, 50), // Set the width and height
              ), // Add functionality here
              child: const Text(
                'Log out',
                style: TextStyle(fontSize: 20), // Larger font size
              ),
            ),
          ),
        ]
      )
    );
  }
}