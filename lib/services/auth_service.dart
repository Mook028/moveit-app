import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Auth State Stream
  Stream<User?> get user => _auth.authStateChanges();

  // Login
  Future<UserCredential> login(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Register
  Future<UserCredential> register(
    String email,
    String password, {
    String? displayName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (displayName != null && displayName.trim().isNotEmpty) {
      await credential.user?.updateDisplayName(displayName.trim());
    }

    return credential;
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Password reset
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
