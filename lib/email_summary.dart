import 'package:flutter/material.dart';
import 'package:jarvis/auth_gate.dart';
import 'widgets/CustomHeader.dart';
import 'z_personal.dart';
import 'z_arrangements.dart';
import 'z_others.dart';
import 'z_promotions.dart';

class EmailSum extends StatelessWidget {
  const EmailSum({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Email Summary',
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),

          // Personal button
          ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Personal()),
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
                      'Personal',
                      style: TextStyle(
                        
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 70.0)),
                    Icon(
                      Icons.volume_up,
                      size: 30.0,
                      color: Colors.white,
                      ),
                    SizedBox(width: 8),
                    
                  ],
                ),
              ),

          /*Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CustomButton(
              label: 'Personal',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Personal()),
                );
              },
            ),
          ),*/
          const SizedBox(height: 40),
          // Promotion button
          ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Promotions()),
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
                      'Promotions',
                      style: TextStyle(
                        
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 60.0)),
                    Icon(
                      Icons.volume_up,
                      size: 30.0,
                      color: Colors.white,
                      ),
                    SizedBox(width: 8),
                    
                  ],
                ),
              ),
          /*Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CustomButton(
              label: 'Promotions',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Promotions()),
                );
              },
            ),
          ),*/
          const SizedBox(height: 40),
          /*// Arrangements button with padding
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CustomButton(
              label: 'Arrangements',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Arrangements()),
                );
              },
            ),
          ),*/

          ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Arrangements()),
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
                      'Arrangements',
                      style: TextStyle(
                        
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 50.0)),
                    Icon(
                      Icons.volume_up,
                      size: 30.0,
                      color: Colors.white,
                      ),
                    SizedBox(width: 8),
                    
                  ],
                ),
              ),

          
          const SizedBox(height: 40),
          
          // Others button
          ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Others()),
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
                      'Others',
                      style: TextStyle(
                        
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 85.0)),
                    Icon(
                      Icons.volume_up,
                      size: 30.0,
                      color: Colors.white,
                      ),
                    SizedBox(width: 8),
                    
                  ],
                ),
              ),

          Expanded(
            child: Container(),
          ),
          
          // Log out button with padding
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0), // Space from bottom
            child: ElevatedButton(
              onPressed: () {
                //Go to welcome screen screen.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthGate()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100), // Rounded shape
                ),
                minimumSize: const Size(double.infinity, 50), // Set the width and height
              ), // Add functionality here
              child: const Text(
                'Log out',
                style: TextStyle(fontSize: 20), // Larger font size
              ),
            ),
          ),
        ],
      ),
    );
  }
}
