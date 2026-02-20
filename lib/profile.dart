import 'package:flutter/material.dart';
import 'package:nook/main.dart';
import 'app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {

  const Profile({super.key});

  State<Profile> createState() => _ProfileState();
}
class _ProfileState extends State<Profile>{

    @override
    Widget build (BuildContext context){
      return Scaffold(

        appBar: AppBar(),
      );
  }
}