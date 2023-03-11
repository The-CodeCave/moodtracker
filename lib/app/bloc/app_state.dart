part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  final bool isInitialized;
  final bool isServiceRegistered;
  final User? user;
  const AppState({
    required this.isInitialized,
    required this.isServiceRegistered,
    this.user,
  });

  @override
  List<Object?> get props => [isInitialized, user?.uid];
}

class AppInitialState extends AppState {
  const AppInitialState() : super(isInitialized: false, isServiceRegistered: false);
}

class AppInitializedState extends AppState {
  const AppInitializedState() : super(isInitialized: true, isServiceRegistered: false);
}

class AppUserUnauthenticatedState extends AppState {
  const AppUserUnauthenticatedState(bool isInitialized) : super(isInitialized: isInitialized, isServiceRegistered: true);
}

class AppUserAuthenticatedState extends AppState {
  const AppUserAuthenticatedState(User user) : super(isInitialized: true, isServiceRegistered: true, user: user);
}

class AppErrorState extends AppState {
  final String? message;
  const AppErrorState(this.message) : super(isInitialized: false, isServiceRegistered: false);
}
