part of 'activity_add_dialog_bloc.dart';

abstract class ActivityAddDialogEvent extends Equatable {
  const ActivityAddDialogEvent();

  @override
  List<Object> get props => [];
}

class ActivityAddDialogChangedEvent extends ActivityAddDialogEvent {
  final String? name;
  final String? hours;
  final Set<String>? selectedSegments;
  const ActivityAddDialogChangedEvent({this.name, this.hours, this.selectedSegments});
}

class ActivityAddDialogCreateEvent extends ActivityAddDialogEvent {
  final String name;
  final String hours;

  const ActivityAddDialogCreateEvent({required this.name, required this.hours});
}
