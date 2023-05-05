import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moodtracker/activitiy/bloc/activity_bloc.dart';
import 'package:moodtracker/activitiy/view/activity_list_tile_leading.dart';
import 'package:moodtracker/activitiy/view/activity_list_tile_trailing.dart';
import '../model/activity.dart';
import '../model/activity_rating.dart';
import 'activity_list_tile_left_behind.dart';

class ActivityListTile extends HookWidget {
  final Activity activity;
  const ActivityListTile({
    required this.activity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final rating = useState(ActivityRating.none);
    return Dismissible(
      background: ActivityListTileLeftBehind(rating: rating.value),
      direction: DismissDirection.endToStart,
      key: Key(activity.id!),
      confirmDismiss: (direction) => _confirmDismiss(rating.value),
      onDismissed: (direction) => _handleDismiss(context, rating.value),
      child: ListTile(
        onTap: () {
          rating.value = _cycleRating(rating.value);
        },
        leading: ActivityListTileLeading(activity: activity),
        trailing:
            ActivityListTileTrailing(activity: activity, rating: rating.value),
        title: Text(activity.name),
      ),
    );
  }

  Future<bool> _confirmDismiss(ActivityRating rating) {
    return Future.value(rating != ActivityRating.none);
  }

  _handleDismiss(BuildContext context, ActivityRating rating) {
    context
        .read<ActivityBloc>()
        .add(ActivitySubmitRatingEvent(activity: activity, rating: rating));
  }

  ActivityRating _cycleRating(ActivityRating currentRating) {
    switch (currentRating) {
      case ActivityRating.none:
        return ActivityRating.bad;
      case ActivityRating.bad:
        return ActivityRating.neutral;
      case ActivityRating.neutral:
        return ActivityRating.good;
      case ActivityRating.good:
        return ActivityRating.bad;
      default:
        return ActivityRating.none;
    }
  }
}
