import 'package:nook/model/managers/AuthManager.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthState {
  loading,
  authenticated,
  unauthenticated,
}

class AuthController {

  Stream<AuthState> get authStateStream {
    return AuthManager().authStateChanges.map((User? user) {
      if (user != null) {
        return AuthState.authenticated;
      } else {
        return AuthState.unauthenticated;
      }
    });
  }
}