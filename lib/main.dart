import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'firebase_options.dart';
import 'auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  LocalJsonLocalization.delegate.directories = ['assets/i18n'];

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});


  static void setLocale(BuildContext context, Locale nuovaLingua) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.cambiaLingua(nuovaLingua);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Locale? _linguaAttuale;

  @override
  void initState() {
    super.initState();
    _caricaLinguaSalvata();
  }


  Future<void> _caricaLinguaSalvata() async {
    final prefs = await SharedPreferences.getInstance();
    String? codiceLingua = prefs.getString('linguaApp');

    if (codiceLingua != null) {
      setState(() {
        _linguaAttuale = Locale(codiceLingua);
      });
    }
  }


  void cambiaLingua(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('linguaApp', locale.languageCode);

    setState(() {
      _linguaAttuale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      locale: _linguaAttuale,

      localizationsDelegates: [
        LocalJsonLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('it', 'IT'),
        Locale('en', 'US'),
      ],
      theme: AppTheme.theme,
      home: const AuthGate()
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
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),

                Center(
                  child: Text('benvenuto'.i18n(),
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 45),

                Text('exp'.i18n(), style: Theme.of(context).textTheme.titleMedium),

                const SizedBox(height: 80),

                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      shape: BoxShape.circle
                  ),
                  child: Icon(
                    Icons.home_rounded,
                    size: 100,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: FilledButton(onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }, child:  Text('accedi'.i18n().toUpperCase())),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: OutlinedButton(onPressed: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=> const RegisterScreen())
                    );
                  }, child:  Text('registrati'.i18n().toUpperCase())),
                ),
              ],
            )),
      ),
    );
  }
}