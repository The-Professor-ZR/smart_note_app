import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends Notifier<ThemeMode> {
  static const String _key = 'theme_mode';

  @override
  ThemeMode build() {
    _load();
    return ThemeMode.system;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    state = ThemeMode.values.firstWhere(
          (m) => m.name == saved,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> toggle(bool currentlyDark) async {
    state = currentlyDark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, state.name);
  }
}

final themeControllerProvider =
NotifierProvider<ThemeController, ThemeMode>(ThemeController.new);