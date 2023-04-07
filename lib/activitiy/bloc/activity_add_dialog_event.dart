part of 'activity_add_dialog_bloc.dart';

abstract class ActivityAddDialogEvent extends Equatable {
  const ActivityAddDialogEvent();

  @override
  List<Object> get props => [];
}

class ActivityAddDialogNameChangedEvent extends ActivityAddDialogEvent {
  final String name;
  const ActivityAddDialogNameChangedEvent(this.name);
}

class ActivityAddDialogHoursChangedEvent extends ActivityAddDialogEvent {
  final String hours;
  const ActivityAddDialogHoursChangedEvent(this.hours);
}

class ActivityAddDialogSelectedSegmentsChangedEvent extends ActivityAddDialogEvent {
  final Set<String> selectedSegments;
  const ActivityAddDialogSelectedSegmentsChangedEvent(this.selectedSegments);
}

class ActivityAddDialogCreateEvent extends ActivityAddDialogEvent {}
