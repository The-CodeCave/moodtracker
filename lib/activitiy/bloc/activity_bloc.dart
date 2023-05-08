import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moodtracker/activitiy/service/activity_service.dart';

import '../model/activity.dart';
import '../model/activity_category.dart';
import '../model/activity_filter.dart';
import '../model/activity_rating.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final ActivityService _service = ActivityService();
  StreamSubscription? _subscription;
  ActivityBloc() : super(ActivityLoadingState()) {
    on<ActivityListUpdatedEvent>(_onActivityListUpdatedEvent);
    on<ActivityAddEvent>(_onActivityAddEvent);
    on<ActivityApplyFilterEvent>(_onActivityApplyFilterEvent);
    on<ActivitySubmitRatingEvent>(_onActivitySubmitRatingEvent);

    _subscription = _service.activityList().listen((activityList) =>
        add(ActivityListUpdatedEvent(activityList: activityList)));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  FutureOr<void> _onActivityAddEvent(
      ActivityAddEvent event, Emitter<ActivityState> emit) {
    _service.add(event.activity);
  }

  FutureOr<void> _onActivityListUpdatedEvent(
      ActivityListUpdatedEvent event, Emitter<ActivityState> emit) async {
    emit(ActivityListUpdatedState(
        activityList: event.activityList, filter: state.filter));
  }

  FutureOr<void> _onActivityApplyFilterEvent(
      ActivityApplyFilterEvent event, Emitter<ActivityState> emit) {
    emit(ActivityListUpdatedState(
        activityList: state.activityList, filter: event.filter));
  }

  FutureOr<void> _onActivitySubmitRatingEvent(
      ActivitySubmitRatingEvent event, Emitter<ActivityState> emit) async {
    //Should auto exit the loading state when the list updates
    emit(ActivityUpdateLoadingState(
      updatingActivity: event.activity,
      activityList: state.activityList,
      filter: state.filter,
    ));
    try {
      await _service.submitRating(
        activityId: event.activity.id!,
        rating: event.rating,
      );
    } catch (e) {
      emit(
        ActivityUpdateErrorState(
          message: "Fehler beim Speichern der Bewertung",
          activityList: state.activityList,
          filter: state.filter,
        ),
      );
    }
  }
}
