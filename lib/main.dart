import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'auth_gate.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('it', 'IT'), // Italiano
        Locale('en', 'US'), // Inglese
      ],
      theme: AppTheme.theme,
      home: const AuthGate(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});



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
                  child: FilledButton(onPressed: (){
                    // Navigazione login
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }, child: const Text('ACCEDI')),
                ),
                SizedBox(height: 20), //spaziatura tra bottoni

                //Bottone REGISTRATI
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: OutlinedButton(onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=> const RegisterScreen())
                    );
                  }, child: const Text('REGISTRATI')),
                ),
              ],
            )),

      ),


    );
  }
}
