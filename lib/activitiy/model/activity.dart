import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String? id;
  final String name;
  final ActivityCategory category;
  final ActivityRating rating;

  const Activity({
    this.id,
    required this.name,
    required this.category,
    required this.rating,
  });

  factory Activity.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var category = ActivityCategory.fromString(snapshot['category']);
    var rating = ActivityRating.fromString(snapshot['rating']);
    return Activity(
      id: snapshot.id,
      name: snapshot['name'],
      category: category,
      rating: rating,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'category': category.name,
      'rating': rating.name,
    };
  }
}

enum ActivityCategory {
  hobby,
  obligation,
  work;

  static ActivityCategory fromString(String s) {
    switch (s) {
      case 'hobby':
        return ActivityCategory.hobby;
      case 'obligation':
        return ActivityCategory.obligation;
      default:
        return ActivityCategory.work;
    }
  }
}

extension ActivityCategoryExtension on ActivityCategory {
  toDisplayName() {
    switch (this) {
      case ActivityCategory.hobby:
        return 'Freizeit';
      case ActivityCategory.obligation:
        return 'Verpflichtung';
      default:
        return 'Arbeit';
    }
  }
}

enum ActivityRating {
  none,
  bad,
  neutral,
  good;

  static ActivityRating fromString(String s) {
    switch (s) {
      case 'bad':
        return ActivityRating.bad;
      case 'neutral':
        return ActivityRating.neutral;
      case 'good':
        return ActivityRating.good;
      default:
        return ActivityRating.none;
    }
  }

  int toNumber() {
    switch (this) {
      case ActivityRating.bad:
        return 0;
      case ActivityRating.neutral:
        return 1;
      case ActivityRating.good:
        return 2;
      default:
        return 0;
    }
  }
}
