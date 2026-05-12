import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/core/services/theme_mode_storage.dart';

class ThemeModeController extends StateNotifier<ThemeMode> {
  final ThemeModeStorage _storage;

  String? _userId;

  ThemeModeController(this._storage) : super(ThemeMode.system);

  Future<void> loadForUser(String userId) async {
    _userId = userId;

    final stored = await _storage.readForUser(userId);
    state = stored ?? ThemeMode.system;
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;

    final userId = _userId;
    if (userId == null) return;

    await _storage.saveForUser(userId, mode);
  }

  Future<void> toggleDark(bool enabled) {
    return setMode(enabled ? ThemeMode.dark : ThemeMode.light);
  }

  void resetToSystem() {
    _userId = null;
    state = ThemeMode.system;
  }
}