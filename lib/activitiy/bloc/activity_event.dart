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
