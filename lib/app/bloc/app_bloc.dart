import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moodtracker/firebase_options.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppInitialState()) {
    on<AppInitializeEvent>(_onAppInitializeEvent);
    add(AppInitializeEvent());
  }

  FutureOr<void> _onAppInitializeEvent(AppInitializeEvent event, Emitter<AppState> emit) async {
    bool isInit = false;
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) => isInit = true).onError(_handleError);

    if (isInit) {
      emit(const AppInitializedState());
    } else {
      emit(const AppErrorState('Firebase Initialization failed.'));
    }
  }

  FutureOr<bool> _handleError(Object error, StackTrace stackTrace) {
    debugPrint(error.toString());
    debugPrint(stackTrace.toString());
    return Future.value(true);
  }
}
