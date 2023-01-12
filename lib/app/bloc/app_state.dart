part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  final bool isInitialized;
  final User? user;
  const AppState({
    required this.isInitialized,
    this.user,
  });

  @override
  List<Object?> get props => [isInitialized, user?.uid];
}

class AppInitialState extends AppState {
  const AppInitialState() : super(isInitialized: false);
}

class AppInitializedState extends AppState {
  const AppInitializedState() : super(isInitialized: true);
}

class AppUserUnauthenticatedState extends AppState {
  const AppUserUnauthenticatedState(bool isInitialized)
      : super(isInitialized: isInitialized);
}

class AppUserAuthenticatedState extends AppState {
  const AppUserAuthenticatedState(User user)
      : super(isInitialized: true, user: user);
}

class AppErrorState extends AppState {
  final String? message;
  const AppErrorState(this.message) : super(isInitialized: false);
}
