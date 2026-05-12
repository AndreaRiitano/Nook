import 'package:firebase_auth/firebase_auth.dart';

class AuthManager {
  Stream<User?> get authStateChanges => FirebaseAuth.instance.authStateChanges();
}