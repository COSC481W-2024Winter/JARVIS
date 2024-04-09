import 'package:flutter/material.dart';
import 'package:jarvis/volumecontrollerscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jarvis/backend/text_to_speech.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String _selectedLanguage = 'en-US';
  double _selectedPitch = 1.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language') ?? 'en-US';
      _selectedPitch = prefs.getDouble('pitch') ?? 1.0;
    });
    text_to_speech().setLanguage(_selectedLanguage);
    text_to_speech().setPitch(_selectedPitch);
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', _selectedLanguage);
    await prefs.setDouble('pitch', _selectedPitch);
  }

  void _setLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
    });
    text_to_speech().setLanguage(language);
    _saveSettings();
  }

  void _setPitch(double pitch) {
    setState(() {
      _selectedPitch = pitch;
    });
    text_to_speech().setPitch(pitch);
    _saveSettings();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          const SizedBox(height: 30),

          // Language dropdown
          const Text(
            'Language',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SizedBox(
              width: 300,
              height: 50,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedLanguage,
                  onChanged: (String? newValue) {
                    _setLanguage(newValue!);
                  },
                  items: <String>['en-US', 'es-ES', 'zh-CN']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(value == 'en-US'
                            ? 'English'
                            : value == 'es-ES'
                                ? 'Spanish'
                                : 'Chinese'),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Pitch dropdown
          const Text(
            'Pitch',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SizedBox(
              width: 300,
              height: 50,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<double>(
                  value: _selectedPitch,
                  onChanged: (double? newValue) {
                    _setPitch(newValue!);
                  },
                  items: <double>[0.0, 0.5, 1.0, 1.5, 2.0]
                      .map<DropdownMenuItem<double>>((double value) {
                    return DropdownMenuItem<double>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(value.toString()),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Volume button with same design as the dropdowns
          const SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  _navigateToVolumeScreen(context);
                },
                child: const Text('Volume'),
              ),
            ),
          ),

          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }

  // Builds the app bar for the settings screen
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back,
            color: Theme.of(context).colorScheme.primary),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text('Settings'),
      centerTitle: true,
    );
  }

  void _navigateToVolumeScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyAppp()),
    );
  }
}