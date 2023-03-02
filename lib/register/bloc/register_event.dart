part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterWithPasskey extends RegisterEvent {
  final String username;

  const RegisterWithPasskey({
    required this.username,
  });

  @override
  List<Object> get props => [username];

  @override
  String toString() => 'RegisterWithPasskey { username: $username }';
}

class RegisterButtonPressed extends RegisterEvent {
  final String username;
  final String password;

  const RegisterButtonPressed({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];

  @override
  String toString() =>
      'RegisterButtonPressed { username: $username, password: $password }';
}
