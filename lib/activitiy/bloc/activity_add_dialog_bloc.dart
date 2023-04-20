import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../model/activity.dart';

part 'activity_add_dialog_event.dart';
part 'activity_add_dialog_state.dart';

class ActivityAddDialogBloc
    extends Bloc<ActivityAddDialogEvent, ActivityAddDialogState> {
  ActivityAddDialogBloc() : super(ActivityAddDialogInitialState()) {
    on<ActivityAddDialogChangedEvent>(_onActivityAddDialogChangedEvent);
    on<ActivityAddDialogCreateEvent>(_onActivityAddDialogCreateEvent);
  }

  FutureOr<void> _onActivityAddDialogChangedEvent(
      ActivityAddDialogChangedEvent event,
      Emitter<ActivityAddDialogState> emit) {
    emit(ActivityAddDialogInitialState(
      name: event.name ?? state.name,
      hours: event.hours ?? state.hours,
      selectedSegments: event.selectedSegments ?? state.selectedSegments,
    ));
  }

  FutureOr<void> _onActivityAddDialogCreateEvent(
      ActivityAddDialogCreateEvent event,
      Emitter<ActivityAddDialogState> emit) {
    String? nameError = _validateName(event.name);
    String? hoursError = _validateHours(event.hours);
    String? selectedSegementsError =
        _validateSelectedSegments(state.selectedSegments);

    bool isValid = nameError == null &&
        hoursError == null &&
        selectedSegementsError == null;

    if (isValid) {
      try {
        // TODO: Implement hours function
        // TODO: rethink the use of rating
        int hoursNum = int.parse(event.hours);
        Activity activity = Activity(
          name: event.name,
          category: ActivityCategory.fromSegments(state.selectedSegments),
          rating: [ActivityRating.none],
          hours: hoursNum,
        );
        emit(ActivityAddDialogSuccessState(activity));
      } catch (_) {
        selectedSegementsError = 'Die Aktivität konnte nicht erstellt werden.';
        emit(
          ActivityAddDialogErrorState(
            name: event.name,
            hours: event.hours,
            selectedSegments: state.selectedSegments,
            nameError: nameError,
            hoursError: hoursError,
            selectedSegmentsError: selectedSegementsError,
          ),
        );
      }
    } else {
      emit(
        ActivityAddDialogErrorState(
          name: event.name,
          hours: event.hours,
          selectedSegments: state.selectedSegments,
          nameError: nameError,
          hoursError: hoursError,
          selectedSegmentsError: selectedSegementsError,
        ),
      );
    }
  }

  String? _validateName(String name) {
    if (name.isEmpty) {
      return 'Pflichtfeld';
    }

    return null;
  }

  String? _validateHours(String hours) {
    if (hours.isEmpty) {
      return 'Pflichtfeld';
    }

    try {
      int.parse(hours);
    } catch (_) {
      return 'Muss eine Zahl sein';
    }

    return null;
  }

  String? _validateSelectedSegments(Set<String> selectedSegments) {
    if (selectedSegments.isEmpty) {
      return 'Pflichtfeld';
    }

    return null;
  }
}
