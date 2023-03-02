part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppInitializeEvent extends AppEvent {}

class AppInitializedEvent extends AppEvent {}

class AppRegisterServicesEvent extends AppEvent {}

class AppRegisterButtonPressed extends AppEvent {}

class AppLoginButtonPressed extends AppEvent {}

class AppAuthUserChangedEvent extends AppEvent {
  final User? user;
  const AppAuthUserChangedEvent(this.user);
}

class AppLogoutEvent extends AppEvent {}
