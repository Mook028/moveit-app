import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _authService.user.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();

    if (trimmedEmail.isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-email',
        message: 'Please enter your email address.',
      );
    }
    if (trimmedPassword.isEmpty) {
      throw FirebaseAuthException(
        code: 'wrong-password',
        message: 'Please enter your password.',
      );
    }

    _isLoading = true;
    notifyListeners();
    try {
      final credential = await _authService.login(
        trimmedEmail,
        trimmedPassword,
      );
      _user = credential.user;
      notifyListeners();
    } on FirebaseAuthException {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String email, String password, {String? name}) async {
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();
    final trimmedName = name?.trim();

    if (trimmedEmail.isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-email',
        message: 'Please enter your email address.',
      );
    }
    if (trimmedPassword.length < 6) {
      throw FirebaseAuthException(
        code: 'weak-password',
        message: 'Password must be at least 6 characters.',
      );
    }

    _isLoading = true;
    notifyListeners();
    try {
      final credential = await _authService.register(
        trimmedEmail,
        trimmedPassword,
        displayName: trimmedName,
      );

      // Firebase automatically signs in a newly registered user.
      _user = credential.user;
      notifyListeners();
    } on FirebaseAuthException {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  Future<void> resetPassword(String email) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.resetPassword(email);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCredentials({
    required String currentPassword,
    String? newEmail,
    String? newPassword,
  }) async {
    final currentUser = _user;
    if (currentUser == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No authenticated user found.',
      );
    }

    final email = currentUser.email;
    if (email == null || email.trim().isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-email',
        message: 'Current account email is invalid.',
      );
    }

    final trimmedCurrentPassword = currentPassword.trim();
    final trimmedNewEmail = newEmail?.trim();
    final trimmedNewPassword = newPassword?.trim();
    final shouldUpdateEmail =
        trimmedNewEmail != null &&
        trimmedNewEmail.isNotEmpty &&
        trimmedNewEmail != email;
    final shouldUpdatePassword =
        trimmedNewPassword != null && trimmedNewPassword.isNotEmpty;

    if (!shouldUpdateEmail && !shouldUpdatePassword) {
      return;
    }

    if (trimmedCurrentPassword.isEmpty) {
      throw FirebaseAuthException(
        code: 'wrong-password',
        message: 'Please enter your current password.',
      );
    }

    _isLoading = true;
    notifyListeners();
    try {
      await _authService.reauthenticate(
        email: email,
        currentPassword: trimmedCurrentPassword,
      );

      if (shouldUpdateEmail) {
        await _authService.updateEmail(trimmedNewEmail);
      }

      if (shouldUpdatePassword) {
        if (trimmedNewPassword.length < 6) {
          throw FirebaseAuthException(
            code: 'weak-password',
            message: 'Password must be at least 6 characters.',
          );
        }
        await _authService.updatePassword(trimmedNewPassword);
      }

      _user = FirebaseAuth.instance.currentUser;
      notifyListeners();
    } on FirebaseAuthException {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
