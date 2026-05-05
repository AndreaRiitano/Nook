import 'package:flutter/material.dart';
import 'package:nook/model/objects/Review.dart';
import 'package:nook/model/managers/DatabaseManager.dart';

class ReviewTile extends StatelessWidget {
  final Review review;

  const ReviewTile({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          FutureBuilder<String>(
              future: DatabaseManager().getNomeUtenteById(review.userId),
              builder: (context, snapshot) {


                String nomeVisualizzato = "Caricamento...";
                String iniziale = "";


                if (snapshot.connectionState == ConnectionState.done) {
                  nomeVisualizzato = snapshot.data ?? "Utente Sconosciuto";
                  iniziale = nomeVisualizzato.isNotEmpty
                      ? nomeVisualizzato.substring(0, 1).toUpperCase()
                      : "?";
                }

                return Row(
                  children: [
                    // Avatar con Iniziale dinamica
                    CircleAvatar(
                      backgroundColor: Colors.teal.shade100,
                      child: Text(
                        iniziale,
                        style: TextStyle(color: Colors.teal.shade900, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Nome vero e Data
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              nomeVisualizzato,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)
                          ),
                          Text(
                            "${review.data.day}/${review.data.month}/${review.data.year}",
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                    // Stelline
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            review.valutazione.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }
          ),

          const SizedBox(height: 12),

          // Testo del commento
          Text(
            review.commento,
            style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
          ),
        ],
      ),
    );
  }
}