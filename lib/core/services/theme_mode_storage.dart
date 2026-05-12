import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeStorage {
  static const _prefix = 'theme_mode_user_';

  Future<ThemeMode?> readForUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('$_prefix$userId');

    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => null,
    };
  }

  Future<void> saveForUser(String userId, ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();

    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };

    await prefs.setString('$_prefix$userId', value);
  }
}