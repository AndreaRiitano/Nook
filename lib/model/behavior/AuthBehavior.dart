import 'package:firebase_auth/firebase_auth.dart';
import 'package:localization/localization.dart';

class AuthBehavior {
  static String translateAuthError(FirebaseAuthException e) {
    switch (e.code) {
    // Errori comuni a Login e Register
      case 'invalid-email':
        return 'err_invalid_email'.i18n();
      case 'user-disabled':
        return 'err_user_disabled'.i18n();

    // Errori specifici per il Login
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'err_wrong_credentials'.i18n();

    // Errori specifici per la Registration
      case 'weak-password':
        return 'err_weak_password'.i18n();
      case 'email-already-in-use':
        return 'err_email_used'.i18n();

      default:
        return 'err_generic'.i18n();
    }
  }
}