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
import 'package:jarvis/backend/news_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final GoogleSignInService signInService = GoogleSignInService();
  final SpeechToText speechToText = SpeechToText();
  String _wordsSpoken = "";
  String _gptResponse = "";
  String weatherCondition = "";
  String temperature = "";
  bool _isSpeaking = false; // flag to check if the text is being spoken

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

// Example widget method to display weather data
  Widget _displayWeather() {
    if (weatherCondition.isEmpty)
      return SizedBox.shrink(); // Don't display if no data
    return Column(
      children: [
        Text(temperature, style: TextStyle(fontSize: 16)),
        Text(weatherCondition, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  IconButton _buildProfileButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
      iconSize: 40,
      onPressed: () => _navigateToProfileScreen(context),
    );
  }

  IconButton _buildSettingsButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.primary),
      iconSize: 40,
      onPressed: () => _navigateToSettings(context),
    );
  }

  ElevatedButton _buildEmailCategorizationButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _navigateToEmailCategorizationScreen(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shadowColor: Theme.of(context).colorScheme.shadow,
        elevation: 7,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mail,
            size: 24.0,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(width: 8),
          Text(
            'Email Categorization',
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary, fontSize: 16.0),
          ),
        ],
      ),
    );
  }

  // luna - new button for weather
  ElevatedButton _buildWeatherButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          await WeatherService().requestLocationPermission();
          //WeatherService().fetchWeather('Ypsilanti');
          // This currently prints the weather to the console. Later, you can update the UI accordingly.
          final weatherData = await WeatherService().fetchWeather();
          setState(() {
            // Assuming fetchWeather returns a string like "Cloudy, 23°C"
            // You'll need to adjust based on your actual return type and format
            List<String> parts = weatherData.split(" ");
            weatherCondition = parts[6];
            temperature = parts[12];
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shadowColor: Theme.of(context).colorScheme.shadow,
          elevation: 7,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud,
              size: 24.0,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(width: 8),
            Text(
              'Weather Report',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16.0),
            ),
          ],
        ));
  }

  ElevatedButton _buildNewsButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int? lastClickTime = prefs.getInt('lastClickTime');
        int currentTime = DateTime.now().millisecondsSinceEpoch;

        if (_isSpeaking) {
          // if speaking, stop
          await text_to_speech().stop();
          setState(() {
            _isSpeaking = false;
          });
        } else {
          // if not speaking, start
          if (lastClickTime != null && currentTime - lastClickTime < 3600000) {
            // if clicked within the past hour, read the last summarized content
            String? lastSummarizedContent =
                prefs.getString('lastSummarizedContent');
            if (lastSummarizedContent != null) {
              text_to_speech().speak(lastSummarizedContent);
              setState(() {
                _isSpeaking = true;
              });
            }
          } else {
            // if clicked more than an hour ago, summarize the latest news
            final newsContents = await news_service().getTopNews();
            String contents = await text_to_gpt_service()
                .send_to_GPT(newsContents.join('\n'), "news");
            print('Content: $contents');
            text_to_speech().speak(contents);
            setState(() {
              _isSpeaking = true;
            });

            // save the current time and summarized content
            await prefs.setInt('lastClickTime', currentTime);
            await prefs.setString('lastSummarizedContent', contents);
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shadowColor: Theme.of(context).colorScheme.shadow,
        elevation: 7,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.newspaper,
            size: 24.0,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(width: 8),
          Text(
            'News Summary',
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary, fontSize: 16.0),
          ),
        ],
      ),
    );
  }

  Center _buildBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Welcome!', style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 20),
          _buildMicrophoneButton(),
          _buildTranscriptionText(),
          const SizedBox(height: 40),
          _buildEmailCategorizationButton(context),
          const SizedBox(height: 40),
          _buildNewsButton(context),
          const SizedBox(height: 40),
          _buildWeatherButton(context),
          const SizedBox(height: 10), // Adjust spacing as needed
          _displayWeather(), // Display the weather data
        ],
      ),
    );
  }

  IconButton _buildMicrophoneButton() {
    return IconButton(
      icon: Icon(speechToText.isListening ? Icons.mic : Icons.mic_none,
          size: 50.0, color: Theme.of(context).colorScheme.primary),
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

    text_to_speech().speak(generatedText);
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // This method is called when the app is paused or resumed
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // stop speech to text when app is paused
      text_to_speech().stop();
      setState(() {
        _isSpeaking = false;
      });
    }
  }
}
