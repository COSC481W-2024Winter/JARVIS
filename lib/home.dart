import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:jarvis/backend/weather_service.dart';
import 'package:jarvis/profile_screen_jarvis.dart';
import 'package:jarvis/email_categorization_screen.dart';
import 'package:jarvis/backend/email_gmail_signin_service.dart';
import 'package:jarvis/setting.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:jarvis/backend/text_to_gpt_service.dart';
import 'package:jarvis/backend/text_to_speech.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleSignInService signInService = GoogleSignInService();
  final SpeechToText speechToText = SpeechToText();
  final text_to_speech tts = text_to_speech();
  String _wordsSpoken = "";
  String _gptResponse = "";
  String weatherCondition = "";
  String temperature = "";
  Language _selectedLanguage = Language.english;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: _buildSettingsButton(context),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: _buildProfileButton(context),
        ),
      ],
    );
  }

  Widget _buildLanguageSelector() {
    return DropdownButton<Language>(
      value: _selectedLanguage,
      onChanged: (Language? language) {
        if (language != null) {
          setState(() {
            _selectedLanguage = language;
          });
        }
      },
      items: const [
        DropdownMenuItem<Language>(
          value: Language.english,
          child: Text('English'),
        ),
        DropdownMenuItem<Language>(
          value: Language.spanish,
          child: Text('Spanish'),
        ),
        DropdownMenuItem<Language>(
          value: Language.chinese,
          child: Text('Chinese'),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Welcome!', style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 20),
          _buildLanguageSelector(),
          const SizedBox(height: 20),
          _buildMicrophoneButton(),
          _buildTranscriptionText(),
          _buildEmailCategorizationButton(context),
          const SizedBox(height: 40),
          _buildWeatherButton(context),
          const SizedBox(height: 20), // Adjust spacing as needed
          _displayWeather(), // Display the weather data
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  IconButton _buildProfileButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.person, color: const Color(0xFF8FA5FD)),
      iconSize: 40,
      onPressed: () => _navigateToProfileScreen(context),
    );
  }

  IconButton _buildSettingsButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings, color: const Color(0xFF8FA5FD)),
      iconSize: 40,
      onPressed: () => _navigateToSettings(context),
    );
  }

  ElevatedButton _buildEmailCategorizationButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _navigateToEmailCategorizationScreen(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8FA5FD),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shadowColor: Color.fromRGBO(255, 255, 255, 1),
        elevation: 7,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mail,
            size: 24.0,
            color: Colors.white,
          ),
          SizedBox(width: 8),
          Text(
            'Email Categorization',
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        ],
      ),
    );
  }

  ElevatedButton _buildWeatherButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final weatherData = await WeatherService().fetchWeather('Ypsilanti');
        setState(() {
          List<String> parts = weatherData.split(" ");
          weatherCondition = parts[6];
          temperature = parts[12];
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8FA5FD),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        elevation: 0,
      ),
      child: const Text(
        'Weather',
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
    );
  }

  Center _displayWeather() {
    if (weatherCondition.isEmpty)
      return Center(); // Don't display if no data
    return Center(
      child: Column(
        children: [
          Text(temperature, style: TextStyle(fontSize: 16)),
          Text(weatherCondition, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  IconButton _buildMicrophoneButton() {
    return IconButton(
      icon: Icon(
        speechToText.isListening ? Icons.mic : Icons.mic_none,
        size: 50.0,
        color: const Color(0xFF8FA5FD),
      ),
      onPressed: speechToText.isListening ? _stopListening : _startListening,
    );
  }

  Padding _buildTranscriptionText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _wordsSpoken,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 8.0),
          Text(
            _gptResponse,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  void _startListening() async {
    bool available = await speechToText.initialize();
    if (available) {
      await speechToText.listen(onResult: _onSpeechResult);
    } else {
      print("The user has denied the use of speech recognition.");
    }
    setState(() {});
  }

  void _stopListening() async {
    await speechToText.stop();
    Future.delayed(Duration(milliseconds: 200), () {
      processing();
    });
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = result.recognizedWords;
    });

    if (speechToText.isNotListening) {
      Future.delayed(Duration(milliseconds: 200), () {
        processing();
      });
    }
  }

  void processing() async {
    String generatedText =
        await text_to_gpt_service().send_to_GPT(_wordsSpoken, "talk");
    setState(() {
      _gptResponse = generatedText;
      _wordsSpoken = "";
    });

    tts.speak(generatedText, _selectedLanguage);
  }

  void _navigateToProfileScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<ProfileScreenJarvis>(
        builder: (context) => ProfileScreenJarvis(
          appBar: AppBar(title: const Text('User Profile')),
          actions: [SignedOutAction((context) => Navigator.of(context).pop())],
        ),
      ),
    );
  }

  void _navigateToEmailCategorizationScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmailCategorizationScreen()),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Setting()));
  }
}