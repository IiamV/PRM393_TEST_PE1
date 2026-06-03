import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _darkModeKey = 'dark_mode_enabled';

  bool _isDarkMode = false;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  bool get isDarkMode => _isDarkMode;

  Future<void> loadTheme() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      _isDarkMode = preferences.getBool(_darkModeKey) ?? false;
      notifyListeners();
    } catch (_) {
      _isDarkMode = false;
    }
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_darkModeKey, _isDarkMode);
    notifyListeners();
  }
}
