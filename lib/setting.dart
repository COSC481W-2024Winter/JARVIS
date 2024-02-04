import 'package:flutter/material.dart';
import 'customUIWidgets/customButton.dart';
import 'customUIWidgets/CustomHeader.dart';

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Profile'),
      body: Column(
        children: [
          SizedBox(height: 10),

          // Preference button
          CustomButton(
            label: 'Preference',
            onPressed: () {},
          ),

          SizedBox(height: 10),

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
              onPressed: () {}, // Add functionality here
              child: Text(
                'Log out',
                style: TextStyle(fontSize: 20), // Larger font size
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100), // Rounded shape
                ),
                minimumSize:
                    Size(double.infinity, 50), // Set the width and height
              ),
            ),
          ),
        ],
      ),
    );
  }
}
