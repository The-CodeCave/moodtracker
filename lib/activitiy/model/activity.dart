import 'package:cloud_firestore/cloud_firestore.dart';

import 'activity_category.dart';
import 'activity_rating.dart';

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
