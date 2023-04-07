part of 'activity_add_dialog_bloc.dart';

abstract class ActivityAddDialogState extends Equatable {
  final String? name;
  final String? hours;
  final Set<String> selectedSegments;
  const ActivityAddDialogState({this.name, this.hours, this.selectedSegments = const {}});

  @override
  List<Object> get props => [
        name ?? '',
        hours ?? '',
        selectedSegments,
      ];
}

class ActivityAddDialogInitialState extends ActivityAddDialogState {
  const ActivityAddDialogInitialState({super.name, super.hours, super.selectedSegments});
}
