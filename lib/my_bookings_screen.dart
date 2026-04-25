import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localization/localization.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final utente = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'i_tuoi_viaggi'.i18n(),
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      // Controllo di sicurezza
      body: utente == null
          ? const Center(child: Text("Devi effettuare l'accesso per vedere i tuoi viaggi."))

          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('prenotazioni')
            .where('userId', isEqualTo: utente.uid)
            .snapshots(),
        builder: (context, snapshot) {


          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }


          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.flight_takeoff, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'nessuna_prenotazione'.i18n(),
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          var prenotazioni = snapshot.data!.docs;
          prenotazioni.sort((a, b) {
            var dataA = (a.data() as Map<String, dynamic>)['dataPrenotazione'] as Timestamp?;
            var dataB = (b.data() as Map<String, dynamic>)['dataPrenotazione'] as Timestamp?;
            if (dataA == null || dataB == null) return 0;
            return dataB.compareTo(dataA); // Ordine decrescente
          });

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: prenotazioni.length,
            itemBuilder: (context, index) {
              var datiPrenotazione = prenotazioni[index].data() as Map<String, dynamic>;
              return _buildPrenotazioneCard(datiPrenotazione);
            },
          );
        },
      ),
    );
  }

  Widget _buildPrenotazioneCard(Map<String, dynamic> dati) {
    DateTime checkIn = (dati['checkIn'] as Timestamp).toDate();
    DateTime checkOut = (dati['checkOut'] as Timestamp).toDate();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              dati['immagineBnb'] ?? '',
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(width: 90, height: 90, color: Colors.grey.shade200, child: const Icon(Icons.image, color: Colors.grey)),
            ),
          ),
          const SizedBox(width: 16),


          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        dati['titoloBnb'] ?? 'BnB',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                          'confermata'.i18n(),
                          style: TextStyle(color: Colors.green.shade700, fontSize: 10, fontWeight: FontWeight.bold)
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Icon(Icons.calendar_month, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      '${'dal'.i18n()} ${checkIn.day}/${checkIn.month}/${checkIn.year} ${'al'.i18n()} ${checkOut.day}/${checkOut.month}/${checkOut.year}',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('totale_pagato'.i18n(), style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                    Text(
                      '€${dati['prezzoTotale']}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}