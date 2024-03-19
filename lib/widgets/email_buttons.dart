import 'package:flutter/material.dart';
import 'package:jarvis/widgets/CustomHeader.dart';
import 'package:jarvis/auth_gate.dart';

class CombinedScreen extends StatelessWidget {
  final String title;

  const CombinedScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: title,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
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
    );
  }
}