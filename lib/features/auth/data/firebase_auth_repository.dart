import 'package:firebase_auth/firebase_auth.dart';

import 'package:lumen/features/auth/domain/entities/user_entity.dart';
import 'package:lumen/features/auth/domain/errors/auth_failure_code.dart';
import 'package:lumen/features/auth/domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthRepository({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  UserEntity? get currentUser {
    final user = _firebaseAuth.currentUser;
    return user == null ? null : _mapFirebaseUser(user);
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(
      (user) => user == null ? null : _mapFirebaseUser(user),
    );
  }

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthFailure(AuthFailureCode.unknown, 'sign-in: null user');
      }
      return _mapFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      throw _toFailure(e);
    }
  }

  @override
  Future<UserEntity> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthFailure(AuthFailureCode.unknown, 'sign-up: null user');
      }

      await user.updateDisplayName(name.trim());
      await user.reload();

      final updated = _firebaseAuth.currentUser;
      if (updated == null) {
        throw const AuthFailure(
          AuthFailureCode.unknown,
          'sign-up: user gone after reload',
        );
      }
      return _mapFirebaseUser(updated);
    } on FirebaseAuthException catch (e) {
      throw _toFailure(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw _toFailure(e);
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') return; // F23: never reveal existence
      throw _toFailure(e);
    }
  }

  UserEntity _mapFirebaseUser(User user) {
    return UserEntity(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      emailVerified: user.emailVerified,
      createdAt: user.metadata.creationTime,
      lastSignInAt: user.metadata.lastSignInTime,
    );
  }

  AuthFailure _toFailure(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return const AuthFailure(AuthFailureCode.emailAlreadyInUse);
      case 'invalid-email':
        return const AuthFailure(AuthFailureCode.invalidEmail);
      case 'weak-password':
        return const AuthFailure(AuthFailureCode.weakPassword);
      case 'operation-not-allowed':
        return const AuthFailure(AuthFailureCode.operationNotAllowed);
      case 'network-request-failed':
        return const AuthFailure(AuthFailureCode.networkError);
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return const AuthFailure(AuthFailureCode.invalidCredentials);
      case 'too-many-requests':
        return const AuthFailure(AuthFailureCode.tooManyRequests);
      default:
        return AuthFailure(AuthFailureCode.unknown, e.message);
    }
  }
}
