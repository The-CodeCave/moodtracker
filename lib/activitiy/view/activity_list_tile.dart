import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moodtracker/activitiy/bloc/activity_bloc.dart';
import '../model/activity.dart';
import '../model/activity_category.dart';
import '../model/activity_rating.dart';

class ActivityListTile extends HookWidget {
  final _confirmBackgroundOk = Colors.green;
  final _confirmBackgroundNotOk = Colors.red;
  final _saveText = "Speichern";
  final _saveNotValidText = "Bitte Bewertung abgeben";
  final _saveSeparatorWidth = 10.0;
  final _saveIcon = Icons.check;
  final _saveNotOkIcon = Icons.close;
  final _confirmForegroundColor = Colors.white;
  final _confirmTextStyle = const TextStyle(color: Colors.white);

  final Activity activity;
  const ActivityListTile({
    required this.activity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final rating = useState(ActivityRating.none);
    return Dismissible(
      background: _buildLeftBehind(rating.value),
      direction: DismissDirection.endToStart,
      key: Key(activity.id!),
      confirmDismiss: (direction) => _confirmDismiss(rating.value),
      onDismissed: (direction) => _handleDismiss(context, rating.value),
      child: ListTile(
        onTap: () {
          rating.value = _cycleRating(rating.value);
        },
        leading: _buildLeading(),
        trailing: _buildTrailing(rating.value),
        title: Text(activity.name),
      ),
    );
  }

  Widget _buildLeftBehind(ActivityRating rating) {
    late final Widget content;
    if (rating == ActivityRating.none) {
      content = Row(
        children: [
          Icon(_saveNotOkIcon, color: _confirmForegroundColor),
          SizedBox(width: _saveSeparatorWidth),
          Text(_saveNotValidText, style: _confirmTextStyle)
        ],
      );
    } else {
      content = Row(
        children: [
          Icon(_saveIcon, color: _confirmForegroundColor),
          SizedBox(width: _saveSeparatorWidth),
          Text(_saveText, style: _confirmTextStyle)
        ],
      );
    }
    return Container(
      color: rating == ActivityRating.none
          ? _confirmBackgroundNotOk
          : _confirmBackgroundOk,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          content,
          SizedBox(width: _saveSeparatorWidth),
        ],
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

  Icon _buildLeading() {
    switch (activity.category) {
      case ActivityCategory.hobby:
        return Icon(Icons.star);
      case ActivityCategory.obligation:
        return Icon(Icons.home);
      default:
        return Icon(Icons.work);
    }
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

  Widget _buildTrailing(ActivityRating currentRating) {
    // TODO: build as row allow interaction only with last icon
    // TODO: the row shows the recent 5 ratings
    List<Widget> children = [];
    for (var i = 0; i < activity.rating.length.clamp(0, 3); i++) {
      children.add(
        Positioned(
          right: (11 * i).toDouble(),
          top: 0,
          bottom: 0,
          child: Center(
            child: _buildRatingIcon(activity.rating[i], index: i + 1),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 80,
          child: Stack(
            children: children,
          ),
        ),
        _buildRatingIcon(currentRating)
      ],
    );
  }

  Widget _buildRatingIcon(ActivityRating rating, {int index = 0}) {
    switch (rating) {
      case ActivityRating.bad:
        return Icon(
          Icons.sentiment_very_dissatisfied,
          size: 25 * (1 - (index / 7)),
        );
      case ActivityRating.neutral:
        return Icon(
          Icons.sentiment_neutral,
          size: 25 * (1 - (index / 7)),
        );
      case ActivityRating.good:
        return Icon(
          Icons.sentiment_very_satisfied,
          size: 25 * (1 - (index / 7)),
        );
      default:
        return Icon(Icons.do_disturb, size: 25 * (1 - (index / 7)));
    }
  }
}
