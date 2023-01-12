part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  final bool isInitialized;
  const AppState({required this.isInitialized});

  @override
  List<Object?> get props => [isInitialized];
}

class AppInitialState extends AppState {
  const AppInitialState() : super(isInitialized: false);
}

class AppInitializedState extends AppState {
  const AppInitializedState() : super(isInitialized: true);
}

class AppErrorState extends AppState {
  final String? message;
  const AppErrorState(this.message) : super(isInitialized: false);
}

class AppAuthenticatedState extends AppInitializedState {
  final User user;
  const AppAuthenticatedState({required this.user}) : super();
}
