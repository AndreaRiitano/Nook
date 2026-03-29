import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homepage_screen.dart';
class RegisterScreen extends StatefulWidget{

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();

}

class _RegisterScreenState extends State<RegisterScreen>{

  String? _selectedGender;

  final List<String> _genderOptions = ['uomo'.i18n(), 'donna'.i18n(), 'pref'.i18n(), 'altro'.i18n()];
  // CONTROLLER

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cognomeController = TextEditingController();
  final TextEditingController _dataNascitaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();


  Future<void> _selectDate() async {
    // Mostra il calendario a schermo intero o popup
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)), // Parte da 18 anni fa
      firstDate: DateTime(1900),   // Data minima (anno 1900)
      lastDate: DateTime.now(),    // Data massima (Oggi)
      locale: Localizations.localeOf(context),
    );

    if (picked != null) {
      setState(() {
        // formattazione data
        String giorno = picked.day.toString().padLeft(2, '0');
        String mese = picked.month.toString().padLeft(2, '0');
        String anno = picked.year.toString();

        // Scriviamo il risultato nel box
        _dataNascitaController.text = "$giorno/$mese/$anno";
      });
    }
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text('registrati'.i18n(), style: TextStyle(fontSize: 25)),
        ),
        body: SafeArea(child:
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height:20),

              //CAMPO NOME
              TextField(
                controller: _nomeController,
                keyboardType: TextInputType.name,
                decoration: AppTheme.textBoxDecoNome,
              ),

              SizedBox(height: 35),
              //CAMPO COGNOME
              TextField(
                controller: _cognomeController,
                keyboardType: TextInputType.name,
                decoration: AppTheme.textBoxDecoCognome,
              ),

              SizedBox(height: 35,),
              //CAMPO DATA DI NASCITA
              TextField(
                controller: _dataNascitaController, // Collega il controller
                readOnly: true,  // blocca tastiera
                onTap: _selectDate, // parte il calendario al tap.

                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.indigo.shade50,
                  labelText: 'nascita'.i18n(),
                  hintText: 'GG/MM/AAAA', // Testo fantasma

                  prefixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectDate, // apre il calendario anche per tap su icona
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                  ),


                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                  ),
                ),


              SizedBox(height: 35),
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
              SizedBox(height: 35,),

              //TELEFONO
              TextField(
                  controller: _telefonoController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: AppTheme.textBoxDecoTelefono
              ),
              SizedBox(height: 35,),


              DropdownButtonFormField<String>(
                initialValue: _selectedGender,


                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.indigo.shade50,
                  labelText: 'genere'.i18n(),
                  prefixIcon: const Icon(Icons.accessibility_new_rounded),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                ),

                // Lista voci
                items: _genderOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),

                // selezione
                onChanged: (newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },

                // validazione
                validator: (value) {
                  if (value == null) {
                    return 'Seleziona un genere';
                  }
                  return null;
                },
              ),

              //spaziatura
              SizedBox(height: 60,),
              //BOTTONE REGISTRATI
              SizedBox(
                width: double.infinity,
                height: 60,
                child: FilledButton(onPressed: (){
                  _register();
                }, child:  Text('registrati'.i18n().toUpperCase())),
              ),
            ],
          ),
        )
        )
    );
  }

  //eliminazione controller
  @override
  void dispose() {
    _nomeController.dispose();
    _cognomeController.dispose();
    _dataNascitaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }


  Future<void> _register() async {
    // Controllo su tutti i CAMPI
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty ||
        _nomeController.text.isEmpty || _cognomeController.text.isEmpty ||
        _dataNascitaController.text.isEmpty || _selectedGender==null || _telefonoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('f_reg'.i18n())),
      );
      return;
    }

    // caricamento
    showDialog(
      context: context,
      barrierDismissible: false, // Impedisce di chiudere cliccando fuori
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {

      //creazione utente
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        // .trim() per togliere eventuali spazi vuoti
      );

      String uid = userCredential.user!.uid;

      // salvataggio dati nel db
      await FirebaseFirestore.instance.collection('utenti').doc(_emailController.text.trim()).set({
        'email': _emailController.text.trim(),
        'telefono': _telefonoController.text.trim(),
        'dataDiNascita': _dataNascitaController.text,
        'genere': _selectedGender,
        'nome': _nomeController.text.trim(),
        'cognome': _cognomeController.text.trim(),
        'UID': uid,
        'dataCreazioneAccount': FieldValue.serverTimestamp(), // Salva l'ora esatta di registrazione
      });

      // chiusura caricamento
      Navigator.of(context).pop();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomepageScreen()),
            (Route<dynamic> route) => false,
      );

      //creazione avvenuta con successo
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          backgroundColor: Colors.green,
          content: Text('comp_reg'.i18n()),
        ),
      );

    } on FirebaseAuthException catch (e) {
      // Chiudiamo la rotellina in caso di errore
      Navigator.of(context).pop();

      // TRADUZIONE DEGLI ERRORI DI FIREBASE
      String messaggioErrore = 'err_reg'.i18n();

      if (e.code == 'weak-password' && Localizations.localeOf(context)=='it_IT') {
        messaggioErrore = 'La password è troppo debole (minimo 6 caratteri).';
      } else{
        messaggioErrore = e.code;
      }
      if (e.code == 'email-already-in-use'&& Localizations.localeOf(context)=='it_IT') {
        messaggioErrore = 'Esiste già un account Nook con questa email.';
      }else{
        messaggioErrore= e.code;
      }
      if (e.code == 'invalid-email'&& Localizations.localeOf(context)=='it_IT') {
        messaggioErrore = 'Il formato dell\'email non è valido.';
      }else{
        messaggioErrore = e.code;
      }

      // Mostriamo l'errore all'utente con un banner rosso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(messaggioErrore)),
      );
    }
  }

}





