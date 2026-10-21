import 'package:flutter/foundation.dart';

import 'package:lumen/features/auth/domain/entities/user_entity.dart';
import 'package:lumen/features/auth/domain/errors/auth_failure_code.dart';
import 'package:lumen/features/auth/domain/repositories/auth_repository.dart';
import 'package:lumen/features/auth/domain/use_cases/reset_password_use_case.dart';
import 'package:lumen/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:lumen/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:lumen/features/auth/domain/use_cases/sign_up_use_case.dart';

/// Presentation-layer state for every auth flow.
///
/// Keeps only UI concerns: input validation, loading flag, user-facing
/// messages. All backend specifics live behind [AuthRepository]; failures
/// arrive already normalised as [AuthFailure] — no Firebase types here.
class LumenAuthProvider extends ChangeNotifier {
  LumenAuthProvider({
    required AuthRepository repository,
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required SignOutUseCase signOutUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
  }) : _repository = repository,
       _signInUseCase = signInUseCase,
       _signUpUseCase = signUpUseCase,
       _signOutUseCase = signOutUseCase,
       _resetPasswordUseCase = resetPasswordUseCase;

  final AuthRepository _repository;
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  /// Whether an auth operation is currently in flight.
  bool get isLoading => _isLoading;

  /// Last error message for the UI, or `null`.
  String? get errorMessage => _errorMessage;

  /// Last success message for the UI, or `null`.
  String? get successMessage => _successMessage;

  /// The signed-in user, or `null` when signed out.
  UserEntity? get currentUser => _repository.currentUser;

  /// Emits on every auth-state change (sign-in, sign-out, remote revoke).
  /// Screens must listen to this instead of polling [currentUser].
  Stream<UserEntity?> get authStateChanges => _repository.authStateChanges;

  /// Clears transient messages. Call when leaving a form screen.
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  /// Validates the sign-up form and creates the account.
  ///
  /// Returns `true` on success. Navigation must rely on [authStateChanges]
  /// (WrapperScreen handles it), not on this return value.
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required bool acceptedTerms,
  }) async {
    if (_isLoading) return false;
    clearMessages();

    final error = _validateSignUp(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      acceptedTerms: acceptedTerms,
    );
    if (error != null) return _reject(error);

    return _run(
      () => _signUpUseCase(
        name: name.trim(),
        email: email.trim(),
        password: password,
      ),
      successMessage: 'Account created successfully.',
      fallbackMessage: 'Something went wrong. Please try again.',
    );
  }

  /// Validates the sign-in form and signs the user in.
  Future<bool> signIn({required String email, required String password}) async {
    if (_isLoading) return false;
    clearMessages();

    if (email.trim().isEmpty || password.isEmpty) {
      return _reject('Please enter your email and password.');
    }

    return _run(
      () => _signInUseCase(email: email.trim(), password: password),
      successMessage: 'Signed in successfully.',
      fallbackMessage: 'Something went wrong. Please try again.',
    );
  }

  /// Sends a password-reset email.
  ///
  /// The success copy is identical whether or not the account exists,
  /// so the screen cannot be used to enumerate accounts (F23).
  Future<bool> resetPassword({required String email}) async {
    if (_isLoading) return false;
    clearMessages();

    if (!_emailRegex.hasMatch(email.trim())) {
      return _reject('Please enter a valid email address.');
    }

    return _run(
      () => _resetPasswordUseCase(email: email.trim()),
      successMessage: 'Password reset email sent if the account exists.',
      fallbackMessage: 'Could not send the reset email. Please try again.',
    );
  }

  /// Signs the user out.
  Future<bool> signOut() async {
    if (_isLoading) return false;
    clearMessages();

    return _run(
      () => _signOutUseCase(),
      successMessage: 'Signed out successfully.',
      fallbackMessage: 'Unable to sign out. Please try again.',
    );
  }

  // ── internals ──────────────────────────────────────────────────────

  String? _validateSignUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required bool acceptedTerms,
  }) {
    if (name.trim().length < 3) {
      return 'Name must be at least 3 characters.';
    }
    if (!_emailRegex.hasMatch(email.trim())) {
      return 'Please enter a valid email address.';
    }
    if (!_isStrongEnough(password)) {
      return 'Password must be at least 8 characters and include '
          'an uppercase letter and a digit.';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match.';
    }
    if (!acceptedTerms) {
      return 'Please accept the Terms & Conditions.';
    }
    return null;
  }

  /// P1-3: ≥8 chars, ≥1 uppercase, ≥1 digit.
  bool _isStrongEnough(String password) {
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasDigit = password.contains(RegExp(r'[0-9]'));
    return password.length >= 8 && hasUppercase && hasDigit;
  }

  /// Shared loading / try-catch wrapper for all four flows.
  Future<bool> _run(
    Future<void> Function() action, {
    required String successMessage,
    required String fallbackMessage,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await action();
      _successMessage = successMessage;
      return true;
    } on AuthFailure catch (failure) {
      // debugDetail is developer info — log it, never show it (F22).
      assert(() {
        debugPrint('AuthFailure: ${failure.debugDetail ?? failure.code.name}');
        return true;
      }());
      _errorMessage = _messageFor(failure.code);
      return false;
    } catch (_) {
      _errorMessage = fallbackMessage;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool _reject(String message) {
    _errorMessage = message;
    notifyListeners();
    return false;
  }

  /// Maps a domain failure code to user-facing copy.
  /// Never leaks backend text (F21 / F22 / P1-4).
  String _messageFor(AuthFailureCode code) {
    switch (code) {
      case AuthFailureCode.emailAlreadyInUse:
        return 'An account already exists with this email.';
      case AuthFailureCode.invalidEmail:
        return 'Please enter a valid email address.';
      case AuthFailureCode.weakPassword:
        return 'Please choose a stronger password.';
      case AuthFailureCode.operationNotAllowed:
        return 'Sign-up is currently unavailable. Please try again later.';
      case AuthFailureCode.networkError:
        return 'Network error. Check your internet connection.';
      case AuthFailureCode.invalidCredentials:
        return 'Invalid email or password.';
      case AuthFailureCode.tooManyRequests:
        return 'Too many attempts. Please try again later.';
      case AuthFailureCode.unknown:
        return 'Authentication failed. Please try again.';
    }
  }
}
