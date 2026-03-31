import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localization/localization.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final utente = FirebaseAuth.instance.currentUser;

    // se non c'è l'utente torna indietro
    if (utente == null) {
      return const Scaffold(
          body: Center(child: Text("Errore: utente non trovato")));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text('info'.i18n(),
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),


      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('utenti').doc(
            utente.email).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Dati di default
          String nome = 'N.F.';
          String telefono = 'N.F.';
          String cognome = 'N.F.';


          if (snapshot.hasData && snapshot.data != null &&
              snapshot.data!.exists) {
            var dati = snapshot.data!.data() as Map<String, dynamic>?;
            if (dati != null) {
              nome = dati['nome'] ?? 'N.F.';
              telefono = dati['telefono'] ?? 'N.F.';
              cognome = dati['cognome'] ?? 'N.F.';
            }
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
               Text(
                'info_d'.i18n(),
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 30),

              //NOME
              _buildInfoRow(
                titolo: 'nome'.i18n(),
                valore: nome,
                chiaveDatabase: 'nome',
                uid: utente.uid,
                context: context,
              ),
              const Divider(),
              //COGNOME
              _buildInfoRow(
                titolo: 'cognome'.i18n(),
                valore: cognome,
                chiaveDatabase: 'cognome',
                uid: utente.uid,
                context: context,
              ),
              const Divider(),
              // EMAIL
              _buildInfoRow(
                titolo: 'Email',
                valore: utente.email ?? 'Nessuna email',
                // non modificabile al momento
                chiaveDatabase: null,
                uid: null,
                context: null,
              ),
              const Divider(),

              // TELEFONO
              _buildInfoRow(
                titolo: 'telefono'.i18n(),
                valore: telefono,
                chiaveDatabase: 'telefono',
                uid: utente.uid,
                context: context,
              ),
            ],
          );
        },
      ),
    );
  }

  // widget al volo per costruire le righe (da rivedere)
  Widget _buildInfoRow({
    required String titolo,
    required String valore,
    String? chiaveDatabase,
    String? uid,
    BuildContext? context
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titolo,
                    style: const TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 5),
                Text(valore, style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}