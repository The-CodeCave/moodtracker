import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moodtracker/constants.dart';
import 'package:moodtracker/login/model/login_exception.dart';
import 'package:moodtracker/login/service/login_service.dart';
import 'package:moodtracker/login/model/login_provider.dart';
import 'package:moodtracker/setup_services.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late final LoginService _loginService;

  LoginBloc() : super(LoginInitial()) {
    _loginService = getIt.get<LoginService>();
    on<LoginHidePasswordEvent>(_onLoginHidePasswordEvent);
    on<LoginRequestEvent>(_onLoginRequestEvent);
    on<RegisterButtonPressed>(_onRegisterButtonPressed);
  }

  FutureOr<void> _onLoginHidePasswordEvent(LoginHidePasswordEvent event, Emitter<LoginState> emit) {
    emit(LoginInitial(hidePassword: !state.hidePassword));
  }

  FutureOr<void> _onLoginButtonPressed(LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading(hidePassword: state.hidePassword));

    String? emailEmpty;
    String? passwordEmpty;
    if (event.email.isEmpty) {
      emailEmpty = requiredData;
    }
    if (event.password.isEmpty) {
      passwordEmpty = requiredData;
    }

    if (emailEmpty != null || passwordEmpty != null) {
      emit(LoginError(
        message: requiredData,
        emailError: emailEmpty,
        passwordError: passwordEmpty,
      ));
    } else {
      try {
        final user = await _loginService.login(event.email, event.password);
        emit(LoginSuccess(user: user));
      } on LoginException catch (e) {
        switch (e.type) {
          case LoginErrorType.email:
            emit(LoginError(message: e.message, emailError: e.message));
            break;
          case LoginErrorType.password:
            emit(LoginError(message: e.message, passwordError: e.message));
            break;
          default:
            emit(LoginError(message: e.message));
        }
      } catch (e) {
        emit(LoginError(message: e.toString(), hidePassword: state.hidePassword));
      }
    }
  }

  FutureOr<void> _onGoogleLoginButtonPressed(GoogleLoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoadingGoogle());
    try {
      User? user;
      if (event.isWeb) {
        user = await _loginService.signInWithGoogleWeb();
      } else {
        user = await _loginService.signInWithGoogle();
      }
      emit(LoginSuccess(user: user));
    } on Exception catch (e) {
      emit(LoginError(message: e.toString()));
    }
  }

  FutureOr<void> _onAppleLoginButtonPressed(AppleLoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoadingApple());
    try {
      User? user;
      if (event.isWeb) {
        user = await _loginService.signInWithAppleWeb();
      } else {
        user = await _loginService.signInWithApple();
      }
      emit(LoginSuccess(user: user));
    } on Exception catch (e) {
      emit(LoginError(message: e.toString()));
    }
  }

  FutureOr<void> _onRegisterButtonPressed(RegisterButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
  }

  FutureOr<void> _onLoginWithPasskey(LoginWithPasskey event, Emitter<LoginState> emit) async {
    emit(LoginLoadingPasskey());
    try {
      final user = await _loginService.loginWithPasskey();
      if (user != null) {
        emit(LoginSuccess(user: user));
      } else {
        emit(LoginError(message: 'Invalid credentials'));
      }
    } catch (e) {
      emit(LoginError(message: e.toString()));
    }
  }

  FutureOr<void> _onLoginRequestEvent(LoginRequestEvent event, Emitter<LoginState> emit) {
    if (event is LoginButtonPressed) {
      return _onLoginButtonPressed(event, emit);
    } else if (event is GoogleLoginButtonPressed) {
      return _onGoogleLoginButtonPressed(event, emit);
    } else if (event is AppleLoginButtonPressed) {
      return _onAppleLoginButtonPressed(event, emit);
    } else if (event is LoginWithPasskey) {
      return _onLoginWithPasskey(event, emit);
    }
  }
}
