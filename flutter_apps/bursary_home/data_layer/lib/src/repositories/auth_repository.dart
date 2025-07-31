import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Stream<User?> get user {
    return _firebaseAuth.authStateChanges();
  }

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> signInWithGoogle() async {
    if (!kIsWeb) {
      throw UnimplementedError('Google Sign-In is only supported on the web in this app.');
    }

    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider.setCustomParameters({'prompt': 'select_account'});
      await _firebaseAuth.signInWithPopup(googleProvider);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code, e.message);
    } catch (e) {
      throw AuthException('unknown-error', e.toString());
    }
  }

  Future<void> signInWithMicrosoft() async {
    throw AuthException(
      'not-implemented',
      'Microsoft sign-in not yet implemented.',
    );
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code, e.message);
    } catch (e) {
      throw AuthException('unknown-error', e.toString());
    }
  }
}

class AuthException implements Exception {
  final String code;
  final String? message;

  AuthException(this.code, this.message);

  @override
  String toString() {
    return 'AuthException: $code - ${message ?? 'An unknown error occurred.'}';
  }
}
