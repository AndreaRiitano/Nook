import 'package:flutter/material.dart';

class AppTheme {
  //Costruttore privato
  AppTheme._();

  // Colore primario e secondario
  static const Color _primaryColor = Colors.teal;
  static const Color _secondaryColor = Colors.blueGrey;

  // Tema (potenziale lightmode)
  static final ThemeData theme = ThemeData(
    useMaterial3: true,
  //  brightness: Brightness.light,

    // schema colori
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.light,
      secondary: _secondaryColor,
    ),

    // Stile dei testi
    textTheme: const TextTheme(
      // TITOLI GRANDI
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),

        // TITOLI MEDI
        titleMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),

        // CORPO DEL TESTO
        bodyMedium: TextStyle(
          fontSize: 16,
          color: Colors.black87,
          height: 1.5, // Spaziatura righe
        ),

        // TESTO PULSANTI O ETICHETTE
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2, // Lettere un po' spaziate
        )
    ),
  );

}