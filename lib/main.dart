import 'package:flutter/material.dart';
import 'customUIWidgets/CustomBottomNavBar.dart';
import 'customUIWidgets/CustomHeader.dart';

void main() => runApp(MaterialApp(home: CustomBottomNavBar()));

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(title: 'JARVIS'),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Microphone button
              ElevatedButton(
                onPressed: () {

                },
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
            ],
          ),
        ),
      ),
    );
  }
}
