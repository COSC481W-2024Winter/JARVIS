import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jarvis/home.dart';
import 'package:jarvis/volumecontrollerscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jarvis/backend/text_to_speech.dart';
import 'package:volume_controller/volume_controller.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String _selectedLanguage = 'en-US';
  double _selectedPitch = 1.0;
  double _volumeListenerValue = 0;
  double _getVolume = 0;
  double _setVolumeValue = 0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    VolumeController().listener((volume) {
      setState(() => _volumeListenerValue = volume);
    });

    VolumeController().getVolume().then((volume) => _setVolumeValue = volume);
  }

  @override
  void dispose() {
    VolumeController().removeListener();
    super.dispose();
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
              border: Border.all(
                  color: Theme.of(context).colorScheme.primary, width: 2),
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
                  items: <String>['en-US', 'es-ES']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(value == 'en-US' ? 'English' : 'Spanish'),
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
              border: Border.all(
                  color: Theme.of(context).colorScheme.primary, width: 2),
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

          const SizedBox(height: 30),

          const Text(
            'Volume',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          /*
          // Volume button with same design as the dropdowns
          const SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  _navigateToVolumeScreen(context);
                },
                child: 
                const Text(
            'Volume',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
                //const Text('Volume'),
              ),
            ),
          ),

          //Button made by Jacob to replicate the dropdown menu style, quickly discarded
          const SizedBox(height: 30),
          TextButton(onPressed: () {
                  _navigateToVolumeScreen(context);
                }, 
                child: Text(
                  "Volume",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0),
                  ),
                  ),
                ),
                ),*/

          //using text was the easiest thing to do okay
          Row(
            children: [
              Text('aaaaaaaa',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.background)),
              Flexible(
                child: Slider(
                  min: 0,
                  max: 1,
                  onChanged: (double value) {
                    _setVolumeValue = value;
                    VolumeController().setVolume(_setVolumeValue);
                    setState(() {});
                  },
                  value: _setVolumeValue,
                ),
              ),
              Text('aaaaaaaa',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.background)),
            ],
          ),

          TextButton(
            onPressed: () => VolumeController().muteVolume(),
            child: Text('Mute'),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 2.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          // Show system UI
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Text('Show system UI:${VolumeController().showSystemUI}'),
              TextButton(
                onPressed: () => setState(() => VolumeController()
                    .showSystemUI = !VolumeController().showSystemUI),
                child: Text('Show/Hide UI'),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2.0),
                    ),
                  ),
                ),
              )
            ],
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
        onPressed: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        ),
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
