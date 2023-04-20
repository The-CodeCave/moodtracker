import 'package:flutter/material.dart';
import '../model/activity.dart';

class ActivityListTile extends StatelessWidget {
  final Activity activity;
  const ActivityListTile({
    required this.activity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        // TODO: implement tap
      },
      leading: _buildLeading(),
      trailing: _buildTrailing(),
      title: Text(activity.name),
    );
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

  Widget _buildTrailing() {
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
        _buildRatingIcon(ActivityRating.none)
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
