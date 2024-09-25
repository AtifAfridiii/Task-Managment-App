import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  // The key used to store the theme preference in SharedPreferences
  static const String themePreferenceKey = 'themePreference';

  // Boolean to track if dark mode is enabled
  bool _isDarkMode = false;

  // Getter to check if dark mode is enabled
  bool get isDarkMode => _isDarkMode;

  // Constructor to load the theme preference from SharedPreferences
  ThemeProvider() {
    _loadThemePreference();
  }

  // Method to toggle the theme and save the preference
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveThemePreference();
    notifyListeners();
  }

  // Load the theme preference from SharedPreferences
  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(themePreferenceKey) ?? false;
    notifyListeners();
  }

  // Save the theme preference to SharedPreferences
  Future<void> _saveThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(themePreferenceKey, _isDarkMode);
  }
}
