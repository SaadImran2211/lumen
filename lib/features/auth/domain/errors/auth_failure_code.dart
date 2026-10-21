enum AuthFailureCode {
  emailAlreadyInUse,
  invalidEmail,
  weakPassword,
  operationNotAllowed,
  networkError,
  invalidCredentials,
  tooManyRequests,
  unknown,
}

class AuthFailure implements Exception {
  final AuthFailureCode code;
  final String? debugDetail;

  const AuthFailure(this.code, [this.debugDetail]);

  @override
  String toString() =>
      'AuthFailure(${code.name}${debugDetail == null ? '' : ', $debugDetail'})';
}
