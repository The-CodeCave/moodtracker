part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginRequestEvent extends LoginEvent {
  final LoginProvider provider;
  const LoginRequestEvent({required this.provider});
}

class LoginButtonPressed extends LoginRequestEvent {
  final String username;
  final String password;

  const LoginButtonPressed({
    required this.username,
    required this.password,
  }) : super(provider: LoginProvider.moodtracker);

  @override
  List<Object> get props => [username, password];

  // TODO: THIS POSES A HIGH SECURITY RISK
  @override
  String toString() => 'LoginButtonPressed { username: $username, password: $password }';
}

class GoogleLoginButtonPressed extends LoginRequestEvent {
  final bool isWeb;
  const GoogleLoginButtonPressed({required this.isWeb}) : super(provider: LoginProvider.google);
}

class AppleLoginButtonPressed extends LoginRequestEvent {
  const AppleLoginButtonPressed() : super(provider: LoginProvider.apple);
}

class LoginWithPasskey extends LoginRequestEvent {
  const LoginWithPasskey() : super(provider: LoginProvider.applePasskey);
}

class RegisterButtonPressed extends LoginEvent {
  final String username;
  final String password;

  const RegisterButtonPressed({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];

  @override
  String toString() => 'RegisterButtonPressed { username: $username, password: $password }';
}
