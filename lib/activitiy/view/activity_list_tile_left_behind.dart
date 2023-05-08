import 'package:flutter/material.dart';

import '../model/activity_rating.dart';

class ActivityListTileLeftBehind extends StatelessWidget {
  final _confirmBackgroundOk = Colors.green;
  final _confirmBackgroundNotOk = Colors.red;
  final _saveText = "Speichern";
  final _saveNotValidText = "Bitte Bewertung abgeben";
  final _saveSeparatorWidth = 10.0;
  final _saveIcon = Icons.check;
  final _saveNotOkIcon = Icons.close;
  final _confirmForegroundColor = Colors.white;
  final _confirmTextStyle = const TextStyle(color: Colors.white);

  final ActivityRating rating;
  const ActivityListTileLeftBehind({Key? key, required this.rating})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
