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
    switch (activity.rating) {
      case ActivityRating.bad:
        return Icon(Icons.sentiment_very_dissatisfied);
      case ActivityRating.neutral:
        return Icon(Icons.sentiment_neutral);
      case ActivityRating.good:
        return Icon(Icons.sentiment_very_satisfied);
      default:
        return Icon(Icons.do_disturb);
    }
  }
}
