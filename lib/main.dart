import 'package:flutter/material.dart';
import 'widgets/CustomButton.dart';
import 'profile.dart';
import 'setting.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          title: Text('JARVIS'),
          centerTitle: true,
          actions: <Widget>[
            // Profile button
            IconButton(
              iconSize: 40,
              icon: Icon(Icons.account_circle),
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
                child: Icon(
                  Icons.mic,
                  size: 60.0,
                ),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(200, 200),
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                  primary: Colors.blue,
                ),
              ),

              SizedBox(height: 50),

              // Email Summary buttons
              CustomButton(
                label: 'Click to listen email summary',
                onPressed: () {},
              ),

              SizedBox(height: 50),

              // Setting button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Setting()),
                  );
                },
                child: Icon(
                  Icons.settings,
                  size: 30.0,
                ),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                  primary: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
