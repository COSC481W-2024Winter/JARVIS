import 'package:flutter/material.dart';
import 'widgets/CustomSubmitButton.dart';
import 'widgets/CustomHeader.dart';

class Profile extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          // Full name text field
          TextField(
            controller: _textController,
            decoration: InputDecoration(
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

          SizedBox(height: 10),

          // Age text field
          TextField(
            controller: _textController,
            decoration: InputDecoration(
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

          SizedBox(height: 10),

          // story text field
          TextField(
            controller: _textController,
            decoration: InputDecoration(
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

          SizedBox(height: 10),

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
