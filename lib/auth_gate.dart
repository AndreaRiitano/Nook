import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'main.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(

      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        // controlla la memoria
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // se loggato (ha il token) vai alla home
        if (snapshot.hasData) {
          return const HomepageScreen();
        }

        // se non è loggato vai alla welcome
        return const WelcomePage();
      },
    );
  }
}