import 'package:flutter/material.dart';
import 'widgets/CustomSubmitButton.dart';
import 'widgets/CustomHeader.dart';

class Profile extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();

  Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Profile',
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Full name text field
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Age text field
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'Age',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // story text field
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'Your Story',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Submit button
          CustomSubmitButton(
            label: 'Submit',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
