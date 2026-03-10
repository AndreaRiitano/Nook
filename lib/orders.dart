import 'package:flutter/material.dart';
import 'package:nook/main.dart';
import 'app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Orders extends StatefulWidget {

  const Orders({super.key});

  State<Orders> createState() => _OrdersState();
}
class _OrdersState extends State<Orders>{

  @override
  Widget build (BuildContext context){
    return Scaffold(


      body: Text('Ordini'),
    );
  }
}