part of 'activity_bloc.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object> get props => [];
}

class ActivityAddEvent extends ActivityEvent {
  final Activity activity;
  const ActivityAddEvent(this.activity);
}

class ActivityListUpdatedEvent extends ActivityEvent {
  final List<Activity> activityList;
  const ActivityListUpdatedEvent({required this.activityList});
}

class ActivityApplyFilterEvent extends ActivityEvent {
  final ActivityFilter? filter;
  const ActivityApplyFilterEvent({this.filter});
}
