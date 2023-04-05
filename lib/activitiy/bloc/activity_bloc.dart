import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moodtracker/activitiy/service/activity_service.dart';

import '../model/activity.dart';
import '../model/activity_filter.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final ActivityService _service = ActivityService();
  ActivityBloc() : super(ActivityInitial()) {
    on<ActivityAddEvent>(_onActivityAddEvent);
    on<ActivityFetchEvent>(_onActivityFetchEvent);
    on<ActivityApplyFilterEvent>(_onActivityFetchEvent);
    add(ActivityFetchEvent());
  }

  FutureOr<void> _onActivityAddEvent(
      ActivityAddEvent event, Emitter<ActivityState> emit) {
    _service.add(event.activity);
  }

  FutureOr<void> _onActivityFetchEvent(
      ActivityFetchEvent event, Emitter<ActivityState> emit) async {
    final activities = await _service.get();
    if (event is ActivityApplyFilterEvent) {
      emit(
        ActivityLoaded(
          activities
              //TODO: Needs refactoring. Is too complex for "one liner", but works for now
              .where((element) => event.filter.selectedCategory != null
                  ? (element.category == event.filter.selectedCategory)
                  : true &&
                      element.name.contains(event.filter.nameFilter ?? ""))
              .toList(),
          event.filter,
        ),
      );
    } else {
      emit(ActivityLoaded(activities, null));
    }
  }
}
