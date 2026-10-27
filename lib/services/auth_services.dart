import 'package:firebase_auth/firebase_auth.dart';
import '../core/constant/app_strings.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_message(e));
    }
  }

  Future<void> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_message(e));
    }
  }

  Future<void> sendResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(_message(e));
    }
  }

  Future<void> logout() => _auth.signOut();

  String _message(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return AppStrings.errorLogin;
      case 'invalid-email':
        return AppStrings.errorEmail;
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'weak-password':
        return AppStrings.errorPassword;
      case 'network-request-failed':
        return 'No internet connection';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      default:
        return e.message ?? AppStrings.errorGeneric;
    }
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}