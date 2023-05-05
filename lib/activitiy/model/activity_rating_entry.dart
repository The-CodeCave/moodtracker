import 'package:moodtracker/activitiy/model/activity_rating.dart';

class ActivityRatingEntry {
  final String id;
  final String activityId;
  final String userId;
  final ActivityRating rating;
  final DateTime timestamp;

  ActivityRatingEntry({
    required this.id,
    required this.activityId,
    required this.userId,
    required this.rating,
    required this.timestamp,
  });

  factory ActivityRatingEntry.fromJson(Map<String, dynamic> json) {
    return ActivityRatingEntry(
      id: json['id'],
      activityId: json['activityId'],
      userId: json['userId'],
      rating: ActivityRating.fromString(json['rating']),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activityId': activityId,
      'userId': userId,
      'rating': rating.name,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
