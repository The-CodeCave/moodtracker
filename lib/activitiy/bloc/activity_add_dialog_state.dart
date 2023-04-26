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
  const ActivityAddDialogInitialState({
    super.name,
    super.hours,
    super.selectedSegments,
  });
}

class ActivityAddDialogErrorState extends ActivityAddDialogState {
  final String? nameError;
  final String? hoursError;
  final String? selectedSegmentsError;
  const ActivityAddDialogErrorState({
    super.name,
    super.hours,
    super.selectedSegments,
    this.nameError,
    this.hoursError,
    this.selectedSegmentsError,
  });
}

class ActivityAddDialogSuccessState extends ActivityAddDialogState {
  final Activity activity;
  const ActivityAddDialogSuccessState(this.activity);
}
