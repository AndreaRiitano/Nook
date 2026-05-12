import 'package:flutter/material.dart';
import 'package:nook/UI/behavior/AuthController.dart';
import 'package:nook/UI/pages/HomepageScreen.dart';
import '../../main.dart';

class AuthGate extends StatelessWidget {
  final AuthController _controller = AuthController();

  AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(

      stream: _controller.authStateStream,
      initialData: AuthState.loading,

      builder: (context, snapshot) {

        switch (snapshot.data) {
          case AuthState.loading:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );

          case AuthState.authenticated:
            return const HomepageScreen();

          case AuthState.unauthenticated:
            return const WelcomePage();

          default:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
        }
      },
    );
  }
}