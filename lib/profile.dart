import 'package:flutter/material.dart';
import 'package:nook/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'personal_info.dart';
import 'package:localization/localization.dart';
import 'my_bookings_screen.dart';

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
             Text(
                'profilo'.i18n(),
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
                            'ciao'.i18n()+', $nomeMostrato!',
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
             Text('acc_op'.i18n(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // INFORMAZIONI PERSONALI
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.person_outline, color: Colors.black87, size: 28),
              title:  Text('info'.i18n(), style: TextStyle(fontSize: 16)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PersonalInfoScreen())
                );

              },
            ),

            // LE MIE PRENOTAZIONI

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.flight_takeoff, color: Colors.black87),
              title: Text('i_tuoi_viaggi'.i18n()),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyBookingsScreen()),
                );
              },
            ),

            //LINGUA
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.language, color: Colors.black87),


              title: Text('lingua'.i18n(), style: const TextStyle(fontSize: 16)),


              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Localizations.localeOf(context).languageCode == 'it' ? 'Italiano' : 'English',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
              onTap: () {

                _mostraSelettoreLingua(context);
              },
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),

            // SEZIONE SUPPORTO
             Text('supporto'.i18n(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            //voci create con il metodo buildListTitle giusto per fare da placeholder, da sviluppare ed implementare singolarmente
            _buildListTile(Icons.help_outline, 'assistenza'.i18n()),
            _buildListTile(Icons.shield_outlined, 'termini'.i18n()),

            const SizedBox(height: 30),

            // TASTO LOGOUT
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.logout, color: Colors.redAccent, size: 28),
              title:  Text(
                  'esci'.i18n(),
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

  //metodo per selettore lingua
  void _mostraSelettoreLingua(BuildContext context) {

    String linguaAttuale = Localizations.localeOf(context).languageCode;

    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text(
                      'scegli_lingua'.i18n(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 10),

                  // OPZIONE 1: ITALIANO
                  ListTile(
                    leading: const Text('🇮🇹', style: TextStyle(fontSize: 24)),
                    title: const Text('Italiano', style: TextStyle(fontSize: 16)),

                    trailing: linguaAttuale == 'it' ? const Icon(Icons.check, color: Colors.blue) : null,
                    onTap: () {

                      MyApp.setLocale(context, const Locale('it', 'IT'));

                      Navigator.pop(context);
                    },
                  ),

                  // OPZIONE 2: INGLESE
                  ListTile(
                    leading: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
                    title: const Text('English', style: TextStyle(fontSize: 16)),

                    trailing: linguaAttuale == 'en' ? const Icon(Icons.check, color: Colors.blue) : null,
                    onTap: () {

                      MyApp.setLocale(context, const Locale('en', 'US'));

                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
