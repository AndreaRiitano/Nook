import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../aspects/AppTheme.dart';
import 'package:nook/model/managers/DatabaseManager.dart';
import 'package:nook/model/objects/UserNook.dart';
import 'package:nook/model/behavior/AuthBehavior.dart';
import 'HomepageScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? _selectedGender;
  final List<String> _genderOptions = ['uomo'.i18n(), 'donna'.i18n(), 'pref'.i18n(), 'altro'.i18n()];

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cognomeController = TextEditingController();
  final TextEditingController _dataNascitaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();


  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: Localizations.localeOf(context),
    );

    if (picked != null) {
      setState(() {
        _dataNascitaController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  Future<void> _register() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty ||
        _nomeController.text.isEmpty || _cognomeController.text.isEmpty ||
        _dataNascitaController.text.isEmpty || _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor:Colors.red, content: Text('f_reg'.i18n())));
      return;
    }


    _showLoadingDialog();

    try {

      final newUser = UserNook(
        uid: '',
        email: _emailController.text.trim(),
        nome: _nomeController.text.trim(),
        cognome: _cognomeController.text.trim(),
        dataDiNascita: _dataNascitaController.text,
        genere: _selectedGender!,
      );


      await DatabaseManager().registerNewUser(newUser, _passwordController.text.trim());

      if (mounted) {
        Navigator.of(context).pop();
        _onSuccess();
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        Navigator.of(context).pop();

        final errorMsg = AuthBehavior.translateAuthError(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(errorMsg)),
        );
      }
    }
  }



  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.green, content: Text('comp_reg'.i18n())),
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomepageScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('registrati'.i18n(), style: const TextStyle(fontSize: 25)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextField(controller: _nomeController, decoration: AppTheme.textBoxDecoNome(context)),
              const SizedBox(height: 35),
              TextField(controller: _cognomeController, decoration: AppTheme.textBoxDecoCognome(context)),
              const SizedBox(height: 35),
              _buildDatePickerField(),
              const SizedBox(height: 35),
              TextField(controller: _emailController, decoration: AppTheme.textBoxDecoEmail(context)),
              const SizedBox(height: 35),
              TextField(controller: _passwordController, obscureText: true, decoration: AppTheme.textBoxDecoPassword(context)),
              const SizedBox(height: 35),
              _buildGenderDropdown(),
              const SizedBox(height: 60),
              _buildRegisterButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerField() {
    return TextField(
      controller: _dataNascitaController,
      readOnly: true,
      onTap: _selectDate,
      decoration: AppTheme.boxDecoDate(context),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      decoration: AppTheme.boxDecoGender(context),
      items: _genderOptions.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
      onChanged: (val) => setState(() => _selectedGender = val),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: FilledButton(
        onPressed: _register,
        child: Text('registrati'.i18n().toUpperCase()),
      ),
    );
  }

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
}