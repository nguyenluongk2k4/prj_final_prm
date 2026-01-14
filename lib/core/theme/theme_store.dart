import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_store.g.dart';

/// MobX Store quản lý theme (dark/light mode)
class ThemeStore = _ThemeStore with _$ThemeStore;

abstract class _ThemeStore with Store {
  static const String _themeKey = 'theme_mode';

  @observable
  ThemeMode themeMode = ThemeMode.system;

  @observable
  bool isDarkMode = false;

  @action
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_themeKey);
    
    if (themeModeString != null) {
      switch (themeModeString) {
        case 'light':
          themeMode = ThemeMode.light;
          isDarkMode = false;
          break;
        case 'dark':
          themeMode = ThemeMode.dark;
          isDarkMode = true;
          break;
        default:
          themeMode = ThemeMode.system;
          isDarkMode = false;
      }
    }
  }

  @action
  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
    isDarkMode = mode == ThemeMode.dark;
    
    final prefs = await SharedPreferences.getInstance();
    String themeModeString;
    
    switch (mode) {
      case ThemeMode.light:
        themeModeString = 'light';
        break;
      case ThemeMode.dark:
        themeModeString = 'dark';
        break;
      case ThemeMode.system:
        themeModeString = 'system';
        break;
    }
    
    await prefs.setString(_themeKey, themeModeString);
  }

  @action
  Future<void> toggleTheme() async {
    if (themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }
}
