import 'package:flutter/material.dart';
import 'package:nook/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nook/model/managers/DatabaseManager.dart';
import 'package:nook/model/objects/UserNook.dart';
import 'PersonalInfo.dart';
import 'package:localization/localization.dart';
import 'MyBookingsScreen.dart';
import 'package:nook/UI/aspects/AppTheme.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;
    final utenteAuth = FirebaseAuth.instance.currentUser;

    if (utenteAuth == null) return const Center(child: Text("Nessun utente loggato"));

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 120),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'profilo'.i18n(),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    final nuovoTema = isDarkMode ? AppThemeType.chiaro : AppThemeType.scuro;
                    MyApp.setTheme(context, nuovoTema);
                  },
                ),
              ],
            ),
            SizedBox(height: 30,),
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
                      StreamBuilder<UserNook>(
                        stream: DatabaseManager().getUserData(utenteAuth.email!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text('...', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
                          }


                          final user = snapshot.data;
                          return Text(
                            '${'ciao'.i18n()}, ${user?.nome ?? 'Ospite'}!',
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        utenteAuth.email ?? '',
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
            Text('acc_op'.i18n(), style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),

            _buildNavTile(Icons.person_outline, 'info'.i18n(), () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalInfoScreen()));
            }),

            _buildNavTile(Icons.flight_takeoff, 'i_tuoi_viaggi'.i18n(), () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MyBookingsScreen()));
            }),

            _buildLanguageTile(context),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),

            Text('supporto'.i18n(), style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),

            _buildNavTile(Icons.help_outline, 'assistenza'.i18n(), () {}),
            _buildNavTile(Icons.shield_outlined, 'termini'.i18n(), () {}),

            const SizedBox(height: 30),

            // TASTO LOGOUT
            _buildLogoutTile(context),
          ],
        ),
      ),
    );
  }


  Widget _buildNavTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Theme.of(context).colorScheme.onSurface, size: 28),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildLanguageTile(BuildContext context) {
    String linguaCode = Localizations.localeOf(context).languageCode;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.language, color: Theme.of(context).colorScheme.onSurface, size: 28),
      title: Text('lingua'.i18n(), style: const TextStyle(fontSize: 16)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(linguaCode == 'it' ? 'Italiano' : 'English', style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
      onTap: () => _mostraSelettoreLingua(context),
    );
  }

  Widget _buildLogoutTile(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.logout, color: Colors.redAccent, size: 28),
      title: Text('esci'.i18n(), style: const TextStyle(color: Colors.redAccent, fontSize: 18, fontWeight: FontWeight.bold)),
      onTap: () async {
        await FirebaseAuth.instance.signOut();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const WelcomePage()),
                (route) => false,
          );
        }
      },
    );
  }

  void _mostraSelettoreLingua(BuildContext context) {
    String linguaAttuale = Localizations.localeOf(context).languageCode;
    showModalBottomSheet(

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
// ITALIANO
                  ListTile(
                    leading: const Text('🇮🇹', style: TextStyle(fontSize: 24)),
                    title: const Text('Italiano', style: TextStyle(fontSize: 16)),
                    trailing: linguaAttuale == 'it' ? const Icon(Icons.check, color: Colors.blue) : null,
                    onTap: () {
                      MyApp.setLocale(context, const Locale('it', 'IT'));
                      Navigator.pop(context);
                    },
                  ),

// INGLESE
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