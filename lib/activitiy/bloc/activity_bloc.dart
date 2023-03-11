import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moodtracker/activitiy/service/activity_service.dart';

import '../model/activity.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final ActivityService _service = ActivityService();
  ActivityBloc() : super(ActivityInitial()) {
    on<ActivityAddEvent>(_onActivityAddEvent);
  }

  FutureOr<void> _onActivityAddEvent(ActivityAddEvent event, Emitter<ActivityState> emit) {
    _service.add(event.activity);
  }
}
