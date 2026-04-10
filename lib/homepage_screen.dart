import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nook/explore.dart';
import 'package:nook/main.dart';
import 'package:nook/search.dart';
import 'app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile.dart';
class HomepageScreen extends StatefulWidget{

  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();

}

class _HomepageScreenState extends State<HomepageScreen>{
  int _currentIndex = 0;


  @override
  Widget build (BuildContext context){

    return Scaffold(
      extendBody: true,
    /*  appBar: AppBar(
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
    ),*/
    //APPBAR CHE NON SERVIRÀ PIÙ, CODICE QUA DA USARE FINO A QUANDO NON SARÀ IMPLEMENTATO UN VERO LOGOUT
    // ho implementato un logout vero ma mi dispiace togliere questo blocco, mi ci sono affezionato

    backgroundColor: Colors.white,

    body: Stack(
      children: [

        Positioned.fill(child:  _getCurrentPage()),

        Positioned(
            left: 10,
            right: 10,
            bottom: 0,
            child:Container(




            // distanza dai margini dello schermo
              margin:  EdgeInsets.only(left: 20, right: 20, bottom: 15 + MediaQuery.of(context).padding.bottom), //aggiungo al margine basso la barra del telefono se esiste, sennò è +0
              height: 55,
              // forma e ombra della box
              decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.circular(50),
               boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2), // Ombra leggera
                  blurRadius: 15,
                 offset: const Offset(0, 8),
                ),
              ],
              ),

              // contenuto
              child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [

                    //  ESPLORA
                    IconButton(
                      icon: Icon(
                        _currentIndex == 0 ? Icons.explore_rounded : Icons.explore_outlined,
                        color: Colors.black,
                      ),
                        onPressed: () {
                        setState(() { _currentIndex = 0; });
                      },
                    ),

                    //  ORDINI
                    IconButton(
                      icon: Icon(
                        _currentIndex == 1 ? Icons.search_rounded : Icons.search_outlined,
                        color: Colors.black,
                      ),
                        onPressed: () {
                        setState(() { _currentIndex = 1; });
                      },
                    ),

                  //  PROFILO
                  IconButton(
                    icon: Icon(
                      _currentIndex == 2 ? Icons.person_rounded : Icons.person_outline,
                      color: Colors.black,
                    ),
                      onPressed: () {
                      setState(() { _currentIndex = 2; });
                    },
                  ),
               ],
            ),
              ),
        ),

      ]
     )
    );
  }


  Widget _buildExplorePage() {
    return const Explore();
  }

  Widget _buildOrderPage() {

    return const Search();
  }

  Widget _buildProfilePage() {
    return const Profile();
  }

  Widget _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return _buildExplorePage();
      case 1:
        return _buildOrderPage();
      case 2:
        return _buildProfilePage();
      default:
        return _buildExplorePage();
    }
  }


}