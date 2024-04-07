import 'package:flutter/material.dart';
import 'package:jarvis/auth_gate.dart';
import 'package:jarvis/volumecontrollerscreen.dart';
import 'widgets/customButton.dart';
import 'widgets/CustomHeader.dart';


class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Settings',
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // Preference button
          CustomButton(
            label: 'Preferences',
            onPressed: () {},
          ),

          const SizedBox(height: 30),

          //Volume button
          CustomButton(
            label: 'Volume',
            onPressed: () {
              _navigateToVolumeScreen(context);
            },
          ),

           const SizedBox(height: 30),

          // Language button
          CustomButton(
            label: 'Language',
            onPressed: () {},
          ),

          Expanded(
            child: Container(),
          ),
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
        ],
      ),
    );
  }
 void _navigateToVolumeScreen(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyAppp()));
  }
}


