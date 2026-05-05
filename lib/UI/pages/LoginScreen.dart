import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nook/model/managers/DatabaseManager.dart';
import 'package:nook/model/behavior/AuthBehavior.dart';
import 'package:nook/UI/aspects/AppTheme.dart';
import 'HomepageScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor:Colors.red, content: Text('f_reg'.i18n())),
      );
      return;
    }

    _showLoadingDialog();

    try {

      await DatabaseManager().loginUser(
        _emailController.text,
        _passwordController.text,
      );

      if (mounted) {
        Navigator.of(context).pop();
        _onLoginSuccess();
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

  void _onLoginSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.green, content: Text('comp_acc'.i18n())),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('accedi'.i18n(), style: const TextStyle(fontSize: 25)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: AppTheme.textBoxDecoEmail,
              ),
              const SizedBox(height: 35),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: AppTheme.textBoxDecoPassword,
              ),
              const SizedBox(height: 80),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: FilledButton(
                  onPressed: _login,
                  child: Text('accedi'.i18n().toUpperCase()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}