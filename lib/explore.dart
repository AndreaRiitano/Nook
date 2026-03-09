import 'package:flutter/material.dart';
import 'package:nook/main.dart';
import 'app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Explore extends StatefulWidget {

  const Explore({super.key});

  State<Explore> createState() => _ExploreState();
}
class _ExploreState extends State<Explore>{

  @override
  Widget build (BuildContext context){
    return Scaffold(

      body: SafeArea(child: ListView(
        padding: const EdgeInsets.only(bottom: 100), // Spazio extra in fondo per non farci finire sopra la navbar a fine scroll
        children: [
          // Intestazione della pagina
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Esplora',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),

          // 1° Carosello
          _buildTitoloSezione('Placeholder1'),
          _buildCaroselloOrizzontale(),

          // 2° Carosello
          _buildTitoloSezione('Placeholder 2'),
          _buildCaroselloOrizzontale(),

          // 3° Carosello
          _buildTitoloSezione('Placeholder 3'),
          _buildCaroselloOrizzontale(),

          //4° Carosello
          _buildTitoloSezione('Placeholder 4'),
          _buildCaroselloOrizzontale(),
        ],
      ),
      )
    );
  }

  Widget _buildCaroselloOrizzontale() {
    return SizedBox(
      height: 200, // altezza
      child: ListView.builder(
        scrollDirection: Axis.horizontal, //Scorrimento laterale
        itemCount: 5, // elementi carosello
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        itemBuilder: (context, index) {

          // container per ogni scheda
          return Container(
            width: 150, // larghezza
            margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50, // Un colore di sfondo temporaneo
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Spazio per l'immagine, ancora da definire
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade200,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: const Center(child: Icon(Icons.image, color: Colors.white, size: 40)),
                  ),
                ),
                // Testo sotto l'immagine, pure questo da definire
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Elemento ${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sottotitolo',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );

        },
      ),
    );
  }



  Widget _buildTitoloSezione(String titolo) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Text(
        titolo,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}