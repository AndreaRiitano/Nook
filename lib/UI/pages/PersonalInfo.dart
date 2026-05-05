import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nook/model/managers/DatabaseManager.dart';
import 'package:nook/model/objects/UserNook.dart';
import 'package:localization/localization.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final utenteAuth = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'info'.i18n(),
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: utenteAuth == null
          ? const Center(child: Text("Errore: Utente non loggato"))
          : StreamBuilder<UserNook>(
        stream: DatabaseManager().getUserData(utenteAuth.email!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Impossibile caricare i dati"));
          }

          final user = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildInfoTile('nome'.i18n(), user.nome),
              _buildInfoTile('cognome'.i18n(), user.cognome),
              _buildInfoTile('email'.i18n(), user.email),
              _buildInfoTile('data_nascita'.i18n(), user.dataDiNascita),
              _buildInfoTile('genere'.i18n(), user.genere),

              const SizedBox(height: 40),
              Text(
                'ID Utente: ${user.uid}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }


  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 5),
          Text(
            value.isNotEmpty ? value : 'Non specificato',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
        ],
      ),
    );
  }
}