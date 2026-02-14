import 'package:flutter/material.dart';
import 'app_theme.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.theme,
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".



  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0), //safe area + padding per i bordi
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, //centro asse orizzontale
              children: [

                const SizedBox(height: 100), //spazio bordo alto
                //titolo
                Center(
                  child: Text('Benvenuto su Nook',
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                      ),
                ),
                const SizedBox(height: 45),
                
                //sottotitolo
                Text('Inizia la tua esperienza', style: Theme.of(context).textTheme.titleMedium),

                const SizedBox(height: 80),
                //spazio dedicato al logo
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    shape: BoxShape.circle
                  ),
                  child: Icon(
                    Icons.home_rounded, //placeholder icona
                    size: 100,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const Spacer(), //per mandare i bottoni in fondo
                
                //Bottone ACCEDI
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: FilledButton(onPressed: (){}, child: const Text('ACCEDI')),
                ),
                SizedBox(height: 20), //spaziatura tra bottoni

                //Bottone REGISTRATI
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: OutlinedButton(onPressed: (){}, child: const Text('REGISTRATI')),
                ),
              ],
            )),

      ),


    );
  }
}
