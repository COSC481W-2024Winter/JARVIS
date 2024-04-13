import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jarvis/firebase_options.dart';
import 'package:jarvis/theme/theme.dart';
import 'auth_gate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jarvis/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: await DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(create: (context) => ThemeProvider(),
  child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthGate(),
      theme: lightMode,
      darkTheme: darkMode, //MaterialApp cannot be constant or else the theme cannot be used
    );
  }
}
