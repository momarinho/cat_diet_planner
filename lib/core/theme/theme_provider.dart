import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(_loadInitialThemeMode());

  static const _themeModeKey = 'theme_mode';

  static ThemeMode _loadInitialThemeMode() {
    final stored = HiveService.appSettingsBox.get(_themeModeKey) as String?;
    switch (stored) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> toggleTheme() async {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(next);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await HiveService.appSettingsBox.put(_themeModeKey, mode.name);
  }
}

// O Riverpod Provider que expõe o nosso Notifier para o resto do app
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});
