import 'package:flutter/material.dart';

import '../model/activity.dart';
import '../model/activity_category.dart';

//TODO: Upgrade to fully fletched "Activity Category renderer"
class ActivityListTileLeading extends StatelessWidget {
  final Activity activity;
  const ActivityListTileLeading({Key? key, required this.activity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (activity.category) {
      case ActivityCategory.hobby:
        return Icon(Icons.star);
      case ActivityCategory.obligation:
        return Icon(Icons.home);
      default:
        return Icon(Icons.work);
    }
  }
}
