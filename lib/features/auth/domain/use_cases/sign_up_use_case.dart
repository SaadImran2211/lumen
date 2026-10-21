import 'package:lumen/features/auth/domain/entities/user_entity.dart';
import 'package:lumen/features/auth/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  const SignUpUseCase(this.repository);

  Future<UserEntity> call({
    required String name,
    required String email,
    required String password,
  }) {
    return repository.signUp(
      name: name.trim(),
      email: email.trim(),
      password: password,
    );
  }
}
