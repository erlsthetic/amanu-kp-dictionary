import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth =
      FirebaseAuth.instance; //Creates an Firebase Auth Instance/Query

  User? get currentUser => _firebaseAuth.currentUser; //Checks current user

  Stream<User?> get authStateChanges =>
      _firebaseAuth.authStateChanges(); //Gets current auth state

  Future<void> signInWithEmailAndPassword({
    //Sign in auth method
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword({
    //Register auth method
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    //Sign out current user method
    await _firebaseAuth.signOut();
  }
}
