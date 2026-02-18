import 'package:flutter/material.dart';
import 'app_theme.dart';

class RegisterScreen extends StatefulWidget{

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();

}

class _RegisterScreenState extends State<RegisterScreen>{

  String? _selectedGender;

  final List<String> _genderOptions = ['Uomo', 'Donna', 'Preferisco non specificare'];
  // controller mostra data nel box
  final TextEditingController _birthDateController = TextEditingController();

  Future<void> _selectDate() async {
    // Mostra il calendario a schermo intero o popup
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)), // Parte da 18 anni fa
      firstDate: DateTime(1900),   // Data minima (anno 1900)
      lastDate: DateTime.now(),    // Data massima (Oggi)
      locale: const Locale("it", "IT"), // forza italiano
    );

    if (picked != null) {
      setState(() {
        // formattazione data
        String giorno = picked.day.toString().padLeft(2, '0');
        String mese = picked.month.toString().padLeft(2, '0');
        String anno = picked.year.toString();

        // Scriviamo il risultato nel box
        _birthDateController.text = "$giorno/$mese/$anno";
      });
    }
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Registrati', style: TextStyle(fontSize: 25)),
        ),
        body: SafeArea(child:
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height:100),

              //CAMPO NOME
              TextField(
                keyboardType: TextInputType.name,
                decoration: AppTheme.textBoxDecoNome,
              ),

              SizedBox(height: 35),
              //CAMPO COGNOME
              TextField(
                keyboardType: TextInputType.name,
                decoration: AppTheme.textBoxDecoCognome,
              ),

              SizedBox(height: 35,),
              //CAMPO DATA DI NASCITA
              TextField(
                controller: _birthDateController, // Collega il controller


                readOnly: true,  // blocca tastiera
                onTap: _selectDate, // parte il calendario al tap.

                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.indigo.shade50,
                  labelText: 'Data di Nascita',
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
              SizedBox(height: 35,),


              DropdownButtonFormField<String>(
                initialValue: _selectedGender,


                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.indigo.shade50,
                  labelText: 'Genere',
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
              SizedBox(height: 80,),
              //BOTTONE REGISTRATI
              SizedBox(
                width: double.infinity,
                height: 60,
                child: FilledButton(onPressed: (){
                }, child: const Text('REGISTRATI')),
              ),
            ],
          ),
        )
        )
    );
  }
}



