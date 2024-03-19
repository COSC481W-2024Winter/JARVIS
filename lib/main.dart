import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jarvis/firebase_options.dart';
import 'auth_gate.dart';
import 'profile.dart';
import 'setting.dart';
import 'email_summary.dart';
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
              color: const Color(0xFF8FA5FD),
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
                  backgroundColor: const Color(0xFF8FA5FD),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                  shadowColor: Colors.blueGrey,
                  elevation: 10,
                ),
                child: const Icon(
                  Icons.mic,
                  size: 60.0,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 50),

              // Email Summary button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EmailSum()),
                  ); 
                },
                style: ElevatedButton.styleFrom(
                  //shape: const CircleBorder(),
                  backgroundColor: const Color(0xFF8FA5FD),
                  padding: const EdgeInsets.all(20),
                  shadowColor: Colors.blueGrey,
                  elevation: 10,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Emails',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 24.0)),
                    Icon(
                      Icons.mail,
                      size: 30.0,
                      color: Colors.white,
                      ),
                    SizedBox(width: 8),
                    
                  ],
                ),
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
                  backgroundColor: const Color(0xFF8FA5FD),
                  padding: const EdgeInsets.all(20),
                  shadowColor: Colors.blueGrey,
                  elevation: 10,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 24.0)),
                    Icon(
                      Icons.settings,
                      size: 30.0,
                      color: Colors.white,
                      ),
                    SizedBox(width: 8),
                    
                  ],
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
