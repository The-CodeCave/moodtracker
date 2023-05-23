part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  final bool hidePassword;
  const LoginState({this.hidePassword = true});

  @override
  List<Object> get props => [hidePassword];
}

class LoginInitial extends LoginState {
  const LoginInitial({super.hidePassword});
}

class LoginLoading extends LoginState {
  const LoginLoading({super.hidePassword});
}

class LoginLoadingPasskey extends LoginState {}

class LoginLoadingGoogle extends LoginState {}

class LoginLoadingApple extends LoginState {}

class LoginSuccess extends LoginState {
  final User? user;

  const LoginSuccess({required this.user});

  @override
  List<Object> get props => [user ?? ""];
}

class LoginError extends LoginState {
  final String message;
  final String? emailError;
  final String? passwordError;

  const LoginError({
    required this.message,
    this.emailError,
    this.passwordError,
    super.hidePassword,
  });

  @override
  List<Object> get props => [
        message,
        emailError ?? '',
        passwordError ?? '',
      ];
}
