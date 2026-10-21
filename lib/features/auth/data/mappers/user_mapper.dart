import 'package:firebase_auth/firebase_auth.dart';
import 'package:lumen/features/auth/domain/entities/user_entity.dart';

class UserMapper {
  static UserEntity toEntity(User user) {
    return UserEntity(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      emailVerified: user.emailVerified,
      createdAt: user.metadata.creationTime,
      lastSignInAt: user.metadata.lastSignInTime,
    );
  }
}
