import 'package:flutter/material.dart';
import 'package:nook/main.dart';
import 'app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomepageScreen extends StatefulWidget{

  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();



}

class _HomepageScreenState extends State<HomepageScreen>{

  @override
  Widget build (BuildContext context){

    return Scaffold(

      backgroundColor: Colors.white,
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
    )
    );
  }

}