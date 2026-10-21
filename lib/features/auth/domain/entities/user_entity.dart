class UserEntity {
  final String id;
  final String email;
  final String? displayName;
  final bool emailVerified;
  final DateTime? createdAt;
  final DateTime? lastSignInAt;

  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.emailVerified = false,
    this.createdAt,
    this.lastSignInAt,
  });
}
