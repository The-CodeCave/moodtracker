import 'package:firebase_auth/firebase_auth.dart';

import '../../constants.dart';

class LoginException implements Exception {
  final String message;
  final LoginErrorType type;
  const LoginException({
    this.message = unknownError,
    this.type = LoginErrorType.general,
  });

  factory LoginException.fromCode(FirebaseAuthException authException) {
    switch (authException.code) {
      case 'wrong-password':
        return LoginException(
          message: wrongPassword,
          type: LoginErrorType.password,
        );
      case 'invalid-email':
        return LoginException(
          message: invalidEmail,
          type: LoginErrorType.email,
        );
      case 'user-disabled':
        return LoginException(
          message: userDisabled,
          type: LoginErrorType.email,
        );
      case 'user-not-found':
        return LoginException(
          message: userNotFound,
          type: LoginErrorType.email,
        );
      case 'email-already-in-use':
        return LoginException(
          message: wrongPassword,
          type: LoginErrorType.email,
        );
      case 'operation-not-allowed':
        return LoginException(
          message: wrongPassword,
          type: LoginErrorType.general,
        );
      case 'weak-password':
        return LoginException(
          message: wrongPassword,
          type: LoginErrorType.password,
        );
      default:
        return LoginException();
    }
  }
}

enum LoginErrorType {
  email,
  password,
  general,
}
