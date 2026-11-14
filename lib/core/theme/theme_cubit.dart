import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// BLoC Cubit for dynamic Light / Dark / System theme management.
class ThemeCubit extends Cubit<ThemeMode> {
  static const String _boxName = 'settings_box';
  static const String _themeKey = 'theme_mode';

  ThemeCubit() : super(ThemeMode.system) {
    _loadThemeMode();
  }

  void _loadThemeMode() {
    try {
      final box = Hive.isBoxOpen(_boxName)
          ? Hive.box(_boxName)
          : null;
      if (box != null) {
        final savedTheme = box.get(_themeKey, defaultValue: 'system') as String;
        emit(_mapStringToThemeMode(savedTheme));
      }
    } catch (_) {
      // Fallback to system theme if box loading fails
      emit(ThemeMode.system);
    }
  }

  Future<void> toggleTheme() async {
    final nextMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(nextMode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(mode);
    try {
      if (Hive.isBoxOpen(_boxName)) {
        final box = Hive.box(_boxName);
        await box.put(_themeKey, mode.name);
      }
    } catch (_) {}
  }

  ThemeMode _mapStringToThemeMode(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
