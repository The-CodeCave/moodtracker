import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moodtracker/firebase_options.dart';
import 'package:moodtracker/login/bloc/login_service.dart';
import 'package:moodtracker/setup_services.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  StreamSubscription<User?>? _authStateChangesSubscription;

  AppBloc() : super(const AppInitialState()) {
    _setupAuthStateListener();
    on<AppInitializeEvent>(_onAppInitializeEvent);
    on<AppLoginEvent>(_onAppLoginEvent);
    on<AppLogoutEvent>(_onAppLogoutEvent);
    add(AppInitializeEvent());
  }

  FutureOr<void> _onAppInitializeEvent(
      AppInitializeEvent event, Emitter<AppState> emit) async {
    bool isInit = false;
    await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform)
        .then((value) => isInit = true)
        .onError(_handleError);

    if (isInit) {
      emit(const AppInitializedState());
    } else {
      emit(const AppErrorState('Firebase Initialization failed.'));
    }
  }

  FutureOr<void> _onAppLoginEvent(
      AppLoginEvent event, Emitter<AppState> emit) async {
    emit(AppAuthenticatedState(user: event.user));
  }

  FutureOr<void> _onAppLogoutEvent(
      AppLogoutEvent event, Emitter<AppState> emit) async {
    emit(const AppInitializedState());
  }

  void _setupAuthStateListener() {
    _authStateChangesSubscription =
        getIt.get<LoginService>().authStateChanges.listen((User? user) {
      if (user == null) {
        add(AppLogoutEvent());
      } else {
        add(AppLoginEvent(user: user));
      }
    });
  }

  FutureOr<bool> _handleError(Object error, StackTrace stackTrace) {
    debugPrint(error.toString());
    debugPrint(stackTrace.toString());
    return Future.value(true);
  }

  @override
  Future<void> close() {
    _authStateChangesSubscription?.cancel();
    return super.close();
  }
}
