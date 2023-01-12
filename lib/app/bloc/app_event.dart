part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppInitializeEvent extends AppEvent {}

class AppLogoutEvent extends AppEvent {}

class AppLoginEvent extends AppEvent {
  final User user;

  const AppLoginEvent({required this.user});

  @override
  List<Object?> get props => [user];
}
