import 'package:flutter/material.dart';
import 'package:nook/main.dart';
import 'app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Order extends StatefulWidget {

  const Order({super.key});

  State<Order> createState() => _OrderState();
}
class _OrderState extends State<Order>{

  @override
  Widget build (BuildContext context){
    return Scaffold(


      body: Text('Ordini'),
    );
  }
}