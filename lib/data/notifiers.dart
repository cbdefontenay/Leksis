import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<int> selectedPageNotifier = ValueNotifier<int>(0);
ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier<ThemeMode>(
  ThemeMode.system,
);

Future<void> loadThemeMode() async {
  final prefs = await SharedPreferences.getInstance();
  final themeIndex = prefs.getInt('themeMode') ?? ThemeMode.system.index;
  themeModeNotifier.value = ThemeMode.values[themeIndex];
}

Future<void> saveThemeMode(ThemeMode themeMode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('themeMode', themeMode.index);
}
