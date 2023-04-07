import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'activity_add_dialog_event.dart';
part 'activity_add_dialog_state.dart';

class ActivityAddDialogBloc extends Bloc<ActivityAddDialogEvent, ActivityAddDialogState> {
  ActivityAddDialogBloc() : super(ActivityAddDialogInitialState()) {
    on<ActivityAddDialogNameChangedEvent>(_onActivityAddNameChangedEvent);
    on<ActivityAddDialogHoursChangedEvent>(_onActivityAddHoursChangedEvent);
    on<ActivityAddDialogSelectedSegmentsChangedEvent>(_onActivitySelectedSegmentsChangedEvent);
  }

  FutureOr<void> _onActivityAddNameChangedEvent(ActivityAddDialogNameChangedEvent event, Emitter<ActivityAddDialogState> emit) {
    emit(ActivityAddDialogInitialState(
      name: event.name,
      hours: state.hours,
      selectedSegments: state.selectedSegments,
    ));
  }

  FutureOr<void> _onActivityAddHoursChangedEvent(ActivityAddDialogHoursChangedEvent event, Emitter<ActivityAddDialogState> emit) {
    emit(ActivityAddDialogInitialState(
      name: state.name,
      hours: event.hours,
      selectedSegments: state.selectedSegments,
    ));
  }

  FutureOr<void> _onActivitySelectedSegmentsChangedEvent(
      ActivityAddDialogSelectedSegmentsChangedEvent event, Emitter<ActivityAddDialogState> emit) {
    emit(ActivityAddDialogInitialState(
      name: state.name,
      hours: state.hours,
      selectedSegments: event.selectedSegments,
    ));
  }
}
