import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String? id;
  final String name;
  final ActivityCategory category;
  final List<ActivityRating> rating;
  final int hours;

  const Activity({
    this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.hours,
  });

  factory Activity.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var category = ActivityCategory.fromString(snapshot['category']);
    List<dynamic> rating =
        snapshot['rating'].map((e) => ActivityRating.fromString(e)).toList();
    final cast = rating.cast<ActivityRating>().toList();
    return Activity(
      id: snapshot.id,
      name: snapshot['name'],
      category: category,
      rating: cast,
      hours: snapshot['hours'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'category': category.name,
      'rating': rating.map((e) => e.name),
      'hours': hours,
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

  static ActivityCategory fromSegments(Set<String> segments) {
    switch (segments.first) {
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
