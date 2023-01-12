part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppInitializeEvent extends AppEvent {}

class AppInitializedEvent extends AppEvent {}

class AppLogoutEvent extends AppEvent {}
