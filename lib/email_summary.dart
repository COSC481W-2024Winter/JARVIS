import 'package:flutter/material.dart';
import 'package:jarvis/auth_gate.dart';
import 'widgets/customButton.dart';
import 'widgets/CustomHeader.dart';
import 'z_personal.dart';
import 'z_arrangements.dart';
import 'z_others.dart';
import 'z_promotions.dart';

class EmailSum extends StatelessWidget {
  const EmailSum({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Email Summary',
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // Personal button with padding
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CustomButton(
              label: 'Personal',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Personal()),
                );
              },
            ),
          ),

          // Promotion button with padding
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CustomButton(
              label: 'Promotions',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Promotions()),
                );
              },
            ),
          ),

          // Arrangements button with padding
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CustomButton(
              label: 'Arrangements',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Arrangements()),
                );
              },
            ),
          ),

          // Others button with padding
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CustomButton(
              label: 'Others',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Others()),
                );
              },
            ),
          ),

          Expanded(
            child: Container(),
          ),
          
          // Log out button with padding
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
                minimumSize: const Size(double.infinity, 50), // Set the width and height
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
}
