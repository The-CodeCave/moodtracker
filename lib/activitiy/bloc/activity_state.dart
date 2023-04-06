part of 'activity_bloc.dart';

abstract class ActivityState extends Equatable {
  final List<Activity> activityList;
  final ActivityFilter? filter;
  const ActivityState({
    this.activityList = const [],
    this.filter,
  });

  List<Activity> get filteredList {
    List<Activity> filteredList = activityList;
    String? nameFilter = filter?.nameFilter;
    if (nameFilter != null) {
      filteredList = filteredList.where((element) => element.name.toLowerCase().contains(nameFilter.toLowerCase())).toList();
    }
    ActivityCategory? category = filter?.selectedCategory;
    if (category != null) {
      filteredList = filteredList.where((element) => element.category == category).toList();
    }
    return filteredList;
  }

  @override
  List<Object> get props => [activityList, filter ?? ''];
}

class ActivityLoadingState extends ActivityState {}

class ActivityListUpdatedState extends ActivityState {
  const ActivityListUpdatedState({
    super.activityList,
    super.filter,
  });
}
