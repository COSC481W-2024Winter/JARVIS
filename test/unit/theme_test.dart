import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis/theme/theme.dart';
import 'package:jarvis/theme/theme_provider.dart';

void main() {
  test('Theme toggling test', () {
    final provider = ThemeProvider();
    
    // Initial theme should be light mode
    expect(provider.themeData, lightMode);
    
    // Toggle theme
    provider.toggleTheme();
    
    // Theme should change to dark mode
    expect(provider.themeData, darkMode);
    
    // Toggle theme again
    provider.toggleTheme();
    
    // Theme should revert back to light mode
    expect(provider.themeData, lightMode);
  });
}
