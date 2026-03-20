import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        title: const Text('Informazioni personali',
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
          String nome = 'Non inserito';
          String telefono = 'Non inserito';
          String cognome = 'Non inserito';


          if (snapshot.hasData && snapshot.data != null &&
              snapshot.data!.exists) {
            var dati = snapshot.data!.data() as Map<String, dynamic>?;
            if (dati != null) {
              nome = dati['nome'] ?? 'Non inserito';
              telefono = dati['telefono'] ?? 'Non inserito';
              cognome = dati['cognome'] ?? 'Non inserito';
            }
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Qui puoi gestire i tuoi dati personali.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 30),

              //NOME
              _buildInfoRow(
                titolo: 'Nome',
                valore: nome,
                chiaveDatabase: 'nome',
                uid: utente.uid,
                context: context,
              ),
              const Divider(),
              //COGNOME
              _buildInfoRow(
                titolo: 'Cognome',
                valore: cognome,
                chiaveDatabase: 'cognome',
                uid: utente.uid,
                context: context,
              ),
              const Divider(),
              // EMAIL
              _buildInfoRow(
                titolo: 'Indirizzo email',
                valore: utente.email ?? 'Nessuna email',
                // non modificabile al momento
                chiaveDatabase: null,
                uid: null,
                context: null,
              ),
              const Divider(),

              // TELEFONO
              _buildInfoRow(
                titolo: 'Numero di telefono',
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