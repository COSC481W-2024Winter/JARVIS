import 'package:flutter/material.dart';
import 'package:jarvis/auth_gate.dart';
import 'package:jarvis/widgets/customButton.dart';
import 'package:jarvis/widgets/email_buttons.dart';

class EmailSum extends StatelessWidget {
  const EmailSum({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Summary'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),

          // Personal button

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CustomButton(
              label: 'Personal',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const CombinedScreen(title: 'Personal')),
                );
              },
            ),
          ),
          const SizedBox(height: 40),
          // Promotion button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CustomButton(
              label: 'Promotions',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const CombinedScreen(title: 'Promotions')),
                );
              },
            ),
          ),
          const SizedBox(height: 40),
          // Arrangements button with padding
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CustomButton(
              label: 'Arrangements',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const CombinedScreen(title: 'Arrangements')),
                );
              },
            ),
          ),
          const SizedBox(height: 40),
          // Others button with padding
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CustomButton(
              label: 'Others',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const CombinedScreen(title: 'Others')),
                );
              },
            ),
          ),

          Expanded(
            child: Container(),
          ),

          // Log out button with padding
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthGate()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Log out',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
