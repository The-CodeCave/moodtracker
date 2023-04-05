import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/activity.dart';

List<Activity> mockList = const [
  Activity(
      name: 'Volleyball',
      category: ActivityCategory.hobby,
      rating: ActivityRating.none),
  Activity(
      name: 'Klavier',
      category: ActivityCategory.hobby,
      rating: ActivityRating.neutral),
  Activity(
      name: 'Tanzen',
      category: ActivityCategory.hobby,
      rating: ActivityRating.none),
  Activity(
      name: 'Programmieren',
      category: ActivityCategory.work,
      rating: ActivityRating.good),
  Activity(
      name: 'Einkauf',
      category: ActivityCategory.obligation,
      rating: ActivityRating.neutral),
  Activity(
      name: 'Bügeln',
      category: ActivityCategory.obligation,
      rating: ActivityRating.bad),
];

class ActivityService {
  final String referenceString = 'activityList';

  Future<String?> add(Activity activity) async {
    return _buildWithConverter().add(activity).then(
          (value) => value.id,
          onError: (e) => throw e,
        );
  }

  Future<List<Activity>> get() async {
    //return _buildWithConverter().get().then(
    //     (value) => value.docs.map((e) => e.data()).toList(),
    //      onError: (e) => throw e,
    //    );
    return Future.value(mockList);
  }

  CollectionReference<Activity> _buildWithConverter() {
    return FirebaseFirestore.instance.collection(referenceString).withConverter(
          fromFirestore: (snapshot, _) => Activity.fromSnapshot(snapshot),
          toFirestore: (activity, _) => activity.toDocument(),
        );
  }
}
