import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moodtracker/login/bloc/login_service.dart';
import 'package:moodtracker/setup_services.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late final LoginService _loginService;

  LoginBloc() : super(LoginInitial()) {
    _loginService = getIt.get<LoginService>();
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<RegisterButtonPressed>(_onRegisterButtonPressed);
  }

  FutureOr<void> _onLoginButtonPressed(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final user = await _loginService.login(event.username, event.password);
      emit(LoginSuccess(user: user));
    } on Exception catch (e) {
      emit(LoginError(message: e.toString()));
    }
  }

  FutureOr<void> _onRegisterButtonPressed(
      RegisterButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final user = await _loginService.register(event.username, event.password);
      emit(LoginSuccess(user: user));
    } on Exception catch (e) {
      emit(LoginError(message: e.toString()));
    }
  }
}