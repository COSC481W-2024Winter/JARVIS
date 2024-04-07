import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade100,                               //Application background
    primary: const Color(0xFF8FA5FD),                               //Main color, used for standard buttons
    secondary: Colors.white,                                        //Accent color, used for text and icons on buttons
    tertiary: const Color.fromARGB(255, 181, 196, 255),             //Color used for toasts
    shadow: const Color.fromRGBO(255, 255, 255, 1),                 //Drop shadow color
    error: Colors.red.shade700,                                     //Color used for delete account and clear summaries buttons
  )
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade900,
    primary: const Color(0xFF8FA5FD),
    secondary: Colors.white,
    tertiary: const Color.fromARGB(255, 116, 144, 255),
    shadow: const Color.fromRGBO(0, 0, 0, 1),
    error: Colors.red.shade500,
  )
);