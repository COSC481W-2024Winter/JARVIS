import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jarvis/firebase_options.dart';
import 'auth_gate.dart';
import 'widgets/CustomButton.dart';
import 'profile.dart';
import 'setting.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: await DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AuthGate(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          title: const Text('JARVIS'),
          centerTitle: true,
          actions: <Widget>[
            // Profile button
            IconButton(
              iconSize: 40,
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Microphone button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 200),
                  backgroundColor: Colors.blue,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Icon(
                  Icons.mic,
                  size: 60.0,
                ),
              ),

              const SizedBox(height: 50),

              // Email Summary buttons
              CustomButton(
                label: 'Click to listen email summary',
                onPressed: () {},
              ),

              const SizedBox(height: 50),

              // Setting button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Setting()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.all(20),
                ),
                child: const Icon(
                  Icons.settings,
                  size: 30.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
