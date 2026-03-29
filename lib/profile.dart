import 'package:flutter/material.dart';
import 'package:nook/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'personal_info.dart';


class Profile extends StatefulWidget {

  const Profile({super.key});

  State<Profile> createState() => _ProfileState();
}
class _ProfileState extends State<Profile>{
  @override
  Widget build(BuildContext context) {

    final utente = FirebaseAuth.instance.currentUser;

    // in caso assurdo non ci sia un utente, manco lo localizzo questo
    if (utente == null) return const Center(child: Text("Nessun utente loggato"));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 120),
          children: [
            const Text(
                'Profilo',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 30),

            // INTESTAZIONE
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(Icons.person, size: 40, color: Colors.grey),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // streambuilder
                      StreamBuilder<DocumentSnapshot>(
                        //snapshot e non get per mantenere lo stream
                        stream: FirebaseFirestore.instance.collection('utenti').doc(utente.email).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Errore', style: TextStyle(color: Colors.red));
                          }

                          // in caso di caricamento
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text('Caricamento...', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
                          }

                          String nomeMostrato = 'Ospite';

                          // controllo aggiuntivo sullo snapshot
                          if (snapshot.hasData && snapshot.data != null) {

                            var documento = snapshot.data!; // se sono qua sicuramente non è vuoto, mi posso permettere il !

                            // Se il documento esiste
                            if (documento.exists && documento.data() != null) {
                              var datiUtente = documento.data() as Map<String, dynamic>;
                              // prendo il nome dal db
                              nomeMostrato = datiUtente['nome'];
                            }
                          }

                          return Text(
                            'Ciao, $nomeMostrato!',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),

                      const SizedBox(height: 4),
                      Text(
                        //se non trova una mail, vuoto
                        utente.email ?? '',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // SEZIONE IMPOSTAZIONI ACCOUNT
            const Text('Impostazioni account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // INFORMAZIONI PERSONALI
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.person_outline, color: Colors.black87, size: 28),
              title: const Text('Informazioni personali', style: TextStyle(fontSize: 16)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PersonalInfoScreen())
                );

              },
            ),

            _buildListTile(Icons.question_mark_outlined, 'deciderò dopo cosa mettere'),
            _buildListTile(Icons.language_outlined, 'Lingua'),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),

            // SEZIONE SUPPORTO
            const Text('Supporto', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            //voci create con il metodo buildListTitle giusto per fare da placeholder, da sviluppare ed implementare singolarmente
            _buildListTile(Icons.help_outline, 'Centro assistenza'),
            _buildListTile(Icons.shield_outlined, 'Termini e privacy'),

            const SizedBox(height: 30),

            // TASTO LOGOUT
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.logout, color: Colors.redAccent, size: 28),
              title: const Text(
                  'Esci',
                  style: TextStyle(color: Colors.redAccent, fontSize: 18, fontWeight: FontWeight.bold)
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const WelcomePage()),
                        (Route<dynamic> route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }


  // Metodo per creare le altre righe, provvisorio, andrà rimosso
  Widget _buildListTile(IconData icon, String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.black87, size: 28),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {},
    );
  }
}
