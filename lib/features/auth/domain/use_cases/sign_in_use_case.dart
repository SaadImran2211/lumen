import 'package:lumen/features/auth/domain/entities/user_entity.dart';
import 'package:lumen/features/auth/domain/repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;

  const SignInUseCase(this.repository);

  Future<UserEntity> call({required String email, required String password}) {
    return repository.signIn(email: email.trim(), password: password);
  }
}
