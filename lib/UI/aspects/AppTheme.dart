import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

enum AppThemeType { chiaro, scuro }

class AppTheme {
  AppTheme._();

  static const Color _secondaryColor = Colors.blueGrey;

  // --- TEMA CHIARO ---
  static final ThemeData chiaro = ThemeData(
    hintColor: Colors.grey.shade100,
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: Colors.black,
      onPrimary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
      secondary: _secondaryColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(foregroundColor: Colors.black, side: const BorderSide(color: Colors.black, width: 1.5)),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
      titleLarge:TextStyle(fontSize: 26, color: Colors.black,fontWeight: FontWeight.bold, height: 1.2),
      titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
      titleSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2),
    ),
  );

  // --- TEMA SCURO ---
  static final ThemeData scuro = ThemeData(
    hintColor: Colors.grey.shade800,
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF222222),
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      onPrimary: Colors.black,
      surface: Color(0xFF222222),
      onSurface: Colors.white,
      secondary: _secondaryColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF222222),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white, width: 1.5)),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
      titleLarge:TextStyle(fontSize: 26, color: Colors.white,fontWeight: FontWeight.bold, height: 1.2),
      titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
      titleSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2),

    ),
  );

  static ThemeData getTheme(AppThemeType type) {
    switch (type) {
      case AppThemeType.chiaro: return chiaro;
      case AppThemeType.scuro: return scuro;
    }
  }


  static InputDecoration _getBaseDecoration(BuildContext context, String label, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final fillColor = isDark ? const Color(0xFF333333) : Colors.indigo.shade50;
    final iconColor = isDark ? Colors.white70 : Colors.black87;
    final labelColor = isDark ? Colors.white70 : Colors.black87;
    final enabledBorderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade400;

    const focusedBorderColor = Colors.teal;
    const errorBorderColor = Colors.red;

    return InputDecoration(
      filled: true,
      fillColor: fillColor,
      labelText: label,
      labelStyle: TextStyle(color: labelColor),
      prefixIcon: Icon(icon, color: iconColor),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: enabledBorderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: focusedBorderColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorBorderColor, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorBorderColor, width: 2),
      ),
    );
  }


  static InputDecoration textBoxDecoEmail(BuildContext context) =>
      _getBaseDecoration(context, 'Email', Icons.email_outlined);

  static InputDecoration textBoxDecoPassword(BuildContext context) =>
      _getBaseDecoration(context, 'Password', Icons.lock_outline);

  static InputDecoration textBoxDecoNome(BuildContext context) =>
      _getBaseDecoration(context, 'nome'.i18n(), Icons.person_outline);

  static InputDecoration textBoxDecoCognome(BuildContext context) =>
      _getBaseDecoration(context, 'cognome'.i18n(), Icons.person_outline);

  static InputDecoration textBoxDecoTelefono(BuildContext context) =>
      _getBaseDecoration(context, 'telefono'.i18n(), Icons.phone_outlined);

  static InputDecoration boxDecoGender(BuildContext context) =>
      _getBaseDecoration(context, 'genere'.i18n(), Icons.accessibility_new_rounded);

  static InputDecoration boxDecoDate(BuildContext context) =>
      _getBaseDecoration(context, 'nascita'.i18n(), Icons.calendar_today);
}