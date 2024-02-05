import 'package:flutter/material.dart';
import '../main.dart';
import '../setting.dart';
import '../profile.dart';


class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({Key? key}) : super(key: key);

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}


class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0; 

  final List<Widget> _pages = [HomePage(), Profile(), Setting()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //arrangement of the bottom navigation bar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
