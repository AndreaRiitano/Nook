import 'package:flutter/material.dart';

class AppTheme {
  //Costruttore privato
  AppTheme._();

  // Colore primario e secondario
  static const Color _primaryColor = Colors.teal;
  static const Color _secondaryColor = Colors.blueGrey;
  static final InputDecoration textBoxDecoEmail = InputDecoration(
    //colore
    filled: true,
    fillColor: Colors.indigo.shade50,
    //etichetta
    labelText: 'Email',
    //icona
    prefixIcon: Icon(Icons.email_outlined),
    // Campo a riposo
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
    ),

    // Quando l'utente ci scrive dentro
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.teal, width: 2),
    ),

    // Errore
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),


  );

  static final InputDecoration textBoxDecoPassword = InputDecoration(
    //colore
      filled: true,
      fillColor: Colors.indigo.shade50,
      //etichetta
      labelText: 'Password',
      //icona
      prefixIcon: Icon(Icons.lock_outline),

      // Campo a riposo
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
      ),

      // Quando l'utente ci scrive dentro
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.teal, width: 2),
      ),

      // Errore
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      )

  );


  static final InputDecoration textBoxDecoNome = InputDecoration(
    //colore
      filled: true,
      fillColor: Colors.indigo.shade50,
      //etichetta
      labelText: 'Nome',
      //icona
      prefixIcon: Icon(Icons.person_outline),

      // Campo a riposo
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
      ),

      // Quando l'utente ci scrive dentro
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.teal, width: 2),
      ),

      // Errore
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      )

  );

  static final InputDecoration textBoxDecoCognome = InputDecoration(
    //colore
      filled: true,
      fillColor: Colors.indigo.shade50,
      //etichetta
      labelText: 'Cognome',
      //icona
      prefixIcon: Icon(Icons.person_outline),

      // Campo a riposo
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
      ),

      // Quando l'utente ci scrive dentro
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.teal, width: 2),
      ),

      // Errore
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      )

  );





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