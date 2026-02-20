import 'package:flutter/material.dart';
import 'package:nook/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nook/homepage_screen.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState () => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen>{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: AppTheme.textBoxDecoEmail
                ),

                //spaziatura
                SizedBox(height: 35),

                //Campo PASSWORD
                TextField(
                  controller: _passwordController,
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
                    _login();
                  }, child: const Text('ACCEDI')),
                ),
              ],
            ),
         )
      )
    );
  }

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // CONTROLLO CAMPI
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inserisci email e password per accedere.')),
      );
      return;
    }

    // CARICAMENTO
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // ACCESSO
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // FINE CARICAMENTE
      Navigator.of(context).pop();

      // SUCCESSO
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Accesso effettuato con successo! Bentornato su Nook.'),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomepageScreen()),
            (Route<dynamic> route) => false,
      );

    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();

      // GESTIONE ERRORI

      String messaggioErrore = 'Errore durante l\'accesso.';

      if (e.code == 'invalid-credential' || e.code == 'user-not-found' || e.code == 'wrong-password') {
        messaggioErrore = 'Email o password non corretti.';
      } else if (e.code == 'invalid-email') {
        messaggioErrore = 'Il formato dell\'email non è valido.';
      } else if (e.code == 'user-disabled') {
        messaggioErrore = 'Questo account è stato disabilitato.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(messaggioErrore)),
      );
    }
  }
}
