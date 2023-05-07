import 'package:flutter/material.dart';

import '../model/activity.dart';
import '../model/activity_rating.dart';

class ActivityListTileTrailing extends StatelessWidget {
  final Activity activity;
  final ActivityRating rating;
  const ActivityListTileTrailing(
      {Key? key, required this.activity, required this.rating})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        _buildRatingIcon(rating)
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
