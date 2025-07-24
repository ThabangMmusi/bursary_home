import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn =
          googleSignIn ??
          GoogleSignIn(
            clientId:
                "627710541896-22qq4qg4hpghslcc4iqt91rt9pfjvbrp.apps.googleusercontent.com",
          ); // REPLACE WITH YOUR ACTUAL WEB CLIENT ID FROM FIREBASE

  Stream<User?> get user {
    return _firebaseAuth.authStateChanges();
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code, e.message);
    } catch (e) {
      throw AuthException('unknown-error', e.toString());
    }
  }

  Future<void> signInWithMicrosoft() async {
    // This is where the Microsoft authentication logic will go.
    // I will need your specific reference/method for Microsoft authentication here.
    // For now, it's a placeholder.
    throw AuthException(
      'not-implemented',
      'Microsoft sign-in not yet implemented.',
    );
  }

  Future<void> signOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
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
