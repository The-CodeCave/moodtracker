// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moodtracker/resetPassword/bloc/reset_password_service.dart';
import 'package:moodtracker/setup_services.dart';
part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  late final ResetPasswordService _resetPasswordService;
  ResetPasswordBloc() : super(ResetPasswordInitial()) {
    _resetPasswordService = getIt.get<ResetPasswordService>();
    on<ResetPasswordButtonPressed>(_onResetPasswordButtonPressed);
  }

  _onResetPasswordButtonPressed(
      ResetPasswordButtonPressed event, Emitter<ResetPasswordState> emit) async {
        _resetPasswordService.sendPasswordResetEmail(event.email);
  }

}
