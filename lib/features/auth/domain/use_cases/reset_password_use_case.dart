import 'package:lumen/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  const ResetPasswordUseCase(this.repository);

  Future<void> call({required String email}) {
    return repository.resetPassword(email: email.trim());
  }
}
