import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moodtracker/register/bloc/register_service.dart';
import 'package:moodtracker/setup_services.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  late final RegisterService _registerService;

  RegisterBloc() : super(RegisterInitial()) {
    _registerService = getIt.get<RegisterService>();
    on<RegisterButtonPressed>(_onRegisterButtonPressed);
    on<RegisterWithPasskey>(_onRegisterWithPasskey);
  }

  FutureOr<void> _onRegisterButtonPressed(
      RegisterButtonPressed event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      final user =
          await _registerService.register(event.username, event.password);
      emit(RegisterSuccess(user: user));
    } catch (e) {
      emit(RegisterError(message: e.toString()));
    }
  }

  FutureOr<void> _onRegisterWithPasskey(
      RegisterWithPasskey event, Emitter<RegisterState> emit) async {
    emit(RegisterLoadingPasskey());
    //TODO: Figure out why the error isnt thrown if the http request fails
    try {
      final user = await _registerService.registerWithPasskey(event.username);
      emit(RegisterSuccess(user: user));
    } catch (e) {
      emit(RegisterError(message: e.toString()));
    }
  }
}
