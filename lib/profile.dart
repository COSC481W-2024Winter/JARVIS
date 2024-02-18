import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/CustomSubmitButton.dart';
import 'widgets/CustomHeader.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _storyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load saved data when the widget is initialized
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullNameController.text = prefs.getString('full_name') ?? '';
      _ageController.text = prefs.getString('age') ?? '';
      _storyController.text = prefs.getString('story') ?? '';
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('full_name', _fullNameController.text);
    prefs.setString('age', _ageController.text);
    prefs.setString('story', _storyController.text);
  }

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
            controller: _fullNameController,
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
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),

          const SizedBox(height: 10),

          // Age text field
          TextField(
            controller: _ageController,
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
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),

          const SizedBox(height: 10),

          // Story text field
          TextField(
            controller: _storyController,
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
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),

          const SizedBox(height: 10),

          // Submit button
          CustomSubmitButton(
            label: 'Submit',
            onPressed: () async {
              await _saveData();
            },
          ),
        ],
      ),
    );
  }
}
