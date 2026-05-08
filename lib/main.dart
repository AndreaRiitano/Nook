import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'UI/aspects/AppTheme.dart';
import 'UI/pages/LoginScreen.dart';
import 'UI/pages/RegisterScreen.dart';
import 'model/aspects/firebase_options.dart';
import 'UI/behavior/AuthGate.dart';
import 'UI/behavior/ThemeController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('1');


  final prefs = await SharedPreferences.getInstance();
  final themeController = ThemeController(prefs);

  LocalJsonLocalization.delegate.directories = ['localizable'];
  print('2');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('3');


  runApp(MyApp(themeController: themeController));
  print('4');
}

class MyApp extends StatefulWidget {
  final ThemeController themeController;

  const MyApp({super.key, required this.themeController});


  static void setLocale(BuildContext context, Locale nuovaLingua) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.cambiaLingua(nuovaLingua);
  }


  static void setTheme(BuildContext context, AppThemeType nuovoTema) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.widget.themeController.changeTheme(nuovoTema);
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
    final prefsLingua = await SharedPreferences.getInstance();
    String? codiceLingua = prefsLingua.getString('linguaApp');

    if (codiceLingua != null) {
      setState(() {
        _linguaAttuale = Locale(codiceLingua);
      });
    }
  }

  void cambiaLingua(Locale locale) async {
    final prefsLingua = await SharedPreferences.getInstance();
    await prefsLingua.setString('linguaApp', locale.languageCode);

    setState(() {
      _linguaAttuale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {

    return ListenableBuilder(
        listenable: widget.themeController,
        builder: (context, _) {
          return MaterialApp(
              title: 'Nook',
              debugShowCheckedModeBanner: false,
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


              theme: widget.themeController.currentThemeData,

              home: const AuthGate()
          );
        }
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

    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;


    final logoPath = isDarkMode
        ? 'assets/images/logo_scuro.png'
        : 'assets/images/logo_chiaro.png';

    return Scaffold(


      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {

              final nuovoTema = isDarkMode ? AppThemeType.chiaro : AppThemeType.scuro;
              MyApp.setTheme(context, nuovoTema);
            },
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                Center(
                  child: Text('benvenuto'.i18n(),
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 45),

                Text('exp'.i18n(), style: Theme.of(context).textTheme.titleMedium),

                const SizedBox(height: 50),

                Container(
                  height: 300,
                  padding: const EdgeInsets.all(30),
                  child: Image.asset(
                    logoPath,
                    fit: BoxFit.cover,),
                ),
                const Spacer(),

                //animazione bottoni
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 1.0, end: 0.0),
                  duration: const Duration(milliseconds: 2200),
                  curve: Curves.easeOutExpo,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 150 * value),
                      child: Opacity(
                        opacity: (1.0 - value).clamp(0.0, 1.0),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: FilledButton(
                            onPressed: (){
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: Text('accedi'.i18n().toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold))
                        ),
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: OutlinedButton(
                            onPressed: (){
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context)=> const RegisterScreen())
                              );
                            },
                            child: Text('registrati'.i18n().toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold))
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            )),
      ),
    );
  }
}