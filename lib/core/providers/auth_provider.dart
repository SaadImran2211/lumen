import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/services/auth_services.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider({AuthService? authService})
    : _authService = authService ?? AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  User? get currentUser => _authService.currentUser;

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> signIn({required String email, required String password}) async {
    if (_isLoading) return false;

    _errorMessage = null;
    _successMessage = null;

    if (email.trim().isEmpty) {
      _errorMessage = 'Please enter your email address.';
    } else if (!_emailRegex.hasMatch(email.trim())) {
      _errorMessage = 'Please enter a valid email address.';
    } else if (password.isEmpty) {
      _errorMessage = 'Please enter your password.';
    }

    if (_errorMessage != null) {
      notifyListeners();
      return false;
    }

    _setLoading(true);

    try {
      await _authService.signIn(email: email, password: password);

      _successMessage = 'Signed in successfully.';
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _firebaseError(e);
      return false;
    } catch (_) {
      _errorMessage = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required bool acceptedTerms,
  }) async {
    if (_isLoading) return false;

    _errorMessage = null;
    _successMessage = null;

    if (name.trim().isEmpty) {
      _errorMessage = 'Please enter your full name.';
    } else if (name.trim().length < 3) {
      _errorMessage = 'Name must be at least 3 characters.';
    } else if (email.trim().isEmpty) {
      _errorMessage = 'Please enter your email address.';
    } else if (!_emailRegex.hasMatch(email.trim())) {
      _errorMessage = 'Please enter a valid email address.';
    } else if (password.isEmpty) {
      _errorMessage = 'Please enter a password.';
    } else if (password.length < 6) {
      _errorMessage = 'Password must be at least 6 characters.';
    } else if (confirmPassword.isEmpty) {
      _errorMessage = 'Please confirm your password.';
    } else if (password != confirmPassword) {
      _errorMessage = 'Passwords do not match.';
    } else if (!acceptedTerms) {
      _errorMessage = 'Please accept the Terms & Conditions to continue.';
    }

    if (_errorMessage != null) {
      notifyListeners();
      return false;
    }

    _setLoading(true);

    try {
      await _authService.createAccount(
        name: name,
        email: email,
        password: password,
      );

      _successMessage = 'Account created successfully! Welcome to Lumen.';
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _firebaseError(e);
      return false;
    } catch (_) {
      _errorMessage = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resetPassword(String email) async {
    _errorMessage = null;
    _successMessage = null;

    if (email.trim().isEmpty || !_emailRegex.hasMatch(email.trim())) {
      _errorMessage = 'Enter a valid email address first.';
      notifyListeners();
      return false;
    }

    _setLoading(true);

    try {
      await _authService.sendPasswordReset(email);
      _successMessage = 'Password reset email sent if the account exists.';
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _firebaseError(e);
      return false;
    } catch (_) {
      _errorMessage = 'Unable to send password reset email.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signOut() async {
    if (_isLoading) return false;

    _errorMessage = null;
    _successMessage = null;
    _setLoading(true);

    try {
      await _authService.signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _firebaseError(e);
      return false;
    } catch (_) {
      _errorMessage = 'Unable to log out. Please try again.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  String _firebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found for this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Please choose a stronger password.';
      case 'operation-not-allowed':
        return 'Email and password sign-up is not enabled in Firebase.';
      case 'network-request-failed':
        return 'Check your internet connection and try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}
