import 'package:flutter/material.dart';
import 'package:nook/main.dart';
import 'app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile.dart';
class HomepageScreen extends StatefulWidget{

  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();

}

class _HomepageScreenState extends State<HomepageScreen>{

  @override
  Widget build (BuildContext context){

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
          title: const Text('Nook Home'),
          actions: [
      // TASTO LOGOUT
      IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () async {

        await FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const WelcomePage()),
              (Route<dynamic> route) => false,
        );
      },
      )
      ]
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0)
          )
    ),
    backgroundColor: Colors.white,
   bottomNavigationBar:_NavBar() ,

    );
  }

  Widget _NavBar() {
    return SafeArea(
      child: Container(
        // distanza dai margini dello schermo
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15),

        // forma e ombra della box
        decoration: BoxDecoration(
          color: Colors.white, // Colore della tua app
          borderRadius: BorderRadius.circular(50), // Il numero magico per la pillola!
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2), // Ombra leggera
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        // contenuto
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0, // niente ombra di default

            // Colori delle icone
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black,

            // testo icone nascosto
            showSelectedLabels: false,
            showUnselectedLabels: false,

            // funzione da mettere nell'ontap, questa è una di prova
            currentIndex: 0,
            onTap: (index) {
              switch (index){

                case 0:
                  break;

                case 1:
                  break;

                case 2:
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Profile(),
                    )
                  );
                  break;
              }
            },

            //icone
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_rounded),
                label: 'Ordini',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Profilo',
              ),
            ],
          ),
        ),
      ),
    );
  }

}