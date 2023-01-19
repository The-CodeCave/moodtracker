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
    on<AppInitializeEvent>(_onAppInitializeEvent);
    on<AppInitializedEvent>(_onAppInitializedEvent);
    on<AppRegisterServicesEvent>(_onAppRegisterServicesEvent);
    on<AppAuthUserChangedEvent>(_onAppAuthUserChangedEvent);
    add(AppInitializeEvent());
  }

  FutureOr<void> _onAppInitializeEvent(AppInitializeEvent event, Emitter<AppState> emit) async {
    bool isInit = false;
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) => isInit = true).onError(_handleError);

    if (isInit) {
      emit(AppInitializedState());
    } else {
      emit(const AppErrorState('Firebase Initialization failed.'));
    }
  }

  FutureOr<void> _onAppInitializedEvent(AppInitializedEvent event, Emitter<AppState> emit) async {}

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

  FutureOr<void> _onAppAuthUserChangedEvent(AppAuthUserChangedEvent event, Emitter<AppState> emit) {
    var user = event.user;
    if (user == null) {
      emit(AppUserUnauthenticatedState(state.isInitialized));
    } else {
      emit(AppUserAuthenticatedState(user));
    }
  }

  FutureOr<void> _onAppRegisterServicesEvent(AppRegisterServicesEvent event, Emitter<AppState> emit) {
    setupServices();
    _authStateChangesSubscription = getIt.get<LoginService>().authStateChanges.listen((User? user) {
      if (state is AppInitializedState) {
        add(AppAuthUserChangedEvent(user));
      }
    });
  }
}
