import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moodtracker/activitiy/model/activity_rating_entry.dart';

import '../model/activity.dart';
import '../model/activity_rating.dart';
import 'package:uuid/uuid.dart';

class ActivityService {
  final String referenceString = 'activityList';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final CollectionReference collectionRef =
      firestore.collection('activityList');

  Stream<List<Activity>> activityList() {
    return _buildWithConverter()
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  CollectionReference<Activity> _buildWithConverter() {
    return collectionRef.withConverter(
      fromFirestore: (snapshot, _) => Activity.fromSnapshot(snapshot),
      toFirestore: (activity, _) => activity.toDocument(),
    );
  }

  Future<String?> add(Activity activity) async {
    return _buildWithConverter().add(activity).then(
          (value) => value.id,
          onError: (e) => throw e,
        );
  }

  Future<String> submitRating({
    required String activityId,
    required ActivityRating rating,
  }) async {
    final current = await _buildWithConverter().doc(activityId).get();
    final activity = current.data()!;
    final newRatingArray = [rating, ...activity.rating.take(2)];

    final ratingId = Uuid().v4();
    final ratingEntry = ActivityRatingEntry(
      id: ratingId,
      activityId: activityId,
      userId: FirebaseAuth.instance.currentUser!.uid,
      rating: rating,
      timestamp: DateTime.now(),
    );

    await firestore.runTransaction((transaction) async {
      transaction.update(
        _buildWithConverter().doc(activityId),
        {'rating': newRatingArray.map((e) => e.name)},
      );
      transaction.set(
        collectionRef.doc(activityId).collection("ratings").doc(ratingId),
        ratingEntry.toJson(),
      );
    });
    return ratingId;
  }
}
