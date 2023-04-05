part of 'activity_bloc.dart';

abstract class ActivityState extends Equatable {
  const ActivityState();

  @override
  List<Object> get props => [];
}

class ActivityInitial extends ActivityState {}

class ActivityLoading extends ActivityState {}

class ActivityLoaded extends ActivityState {
  final ActivityFilter? filter;
  final List<Activity> activities;
  const ActivityLoaded(this.activities, this.filter);

  @override
  List<Object> get props => [activities, filter ?? ActivityFilter()];
}
