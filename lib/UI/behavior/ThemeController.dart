import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../aspects/AppTheme.dart';

class ThemeController with ChangeNotifier {
  static const String _themePrefKey = 'selected_theme';
  final SharedPreferences _prefs;

  // Tema di default se l'utente non ne ha mai scelto uno
  AppThemeType _currentThemeType = AppThemeType.chiaro;

  ThemeController(this._prefs) {
    _loadTheme();
  }

  AppThemeType get currentThemeType => _currentThemeType;
  ThemeData get currentThemeData => AppTheme.getTheme(_currentThemeType);

  void _loadTheme() {
    final savedThemeString = _prefs.getString(_themePrefKey);
    if (savedThemeString != null) {
      _currentThemeType = AppThemeType.values.firstWhere(
            (e) => e.toString() == savedThemeString,
        orElse: () => AppThemeType.chiaro,
      );
    }
    notifyListeners();
  }

  // Cambia tema, salvalo e aggiorna l'app
  Future<void> changeTheme(AppThemeType newTheme) async {
    if (_currentThemeType == newTheme) return;

    _currentThemeType = newTheme;
    await _prefs.setString(_themePrefKey, newTheme.toString());
    notifyListeners();
  }
}