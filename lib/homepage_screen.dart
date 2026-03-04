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
  int _currentIndex = 0;


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

    body: _getCurrentPage(),

    backgroundColor: Colors.white,




   bottomNavigationBar:SafeArea(
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
           currentIndex: _currentIndex,
           onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });

             }
           ,

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
   ) ,

  );
  }


  Widget _buildExplorePage() {
    return const Center(child: Text('Esplora ', style: TextStyle(fontSize: 24)));
  }

  Widget _buildOrderPage() {

    return const Center(child: Text('Ordini', style: TextStyle(fontSize: 24)));
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