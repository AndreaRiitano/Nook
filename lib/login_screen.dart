import 'package:flutter/material.dart';
import 'package:nook/app_theme.dart';


class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState () => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen>{
  
  @override
  Widget build (BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Accedi', style: TextStyle(fontSize: 25)),
      ),
      body: SafeArea(child:
         SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height:100,),
                //CAMPO EMAIL
                TextField(

                  keyboardType: TextInputType.emailAddress,
                  decoration: AppTheme.textBoxDecoEmail
                ),

                //spaziatura
                SizedBox(height: 35),

                //Campo PASSWORD
                TextField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: AppTheme.textBoxDecoPassword
                ),
                //spaziatura
                SizedBox(height: 80),
                //BOTTONE ACCEDI
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: FilledButton(onPressed: (){
                  }, child: const Text('ACCEDI')),
                ),
              ],
            ),
         )
      )
    );
  }
}

//DA INSERIRE CONTROLLER
