import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/activity.dart';

class ActivityService {
  final String referenceString = 'activityList';

  Future<String?> add(Activity activity) async {
    return _buildWithConverter().add(activity).then(
          (value) => value.id,
          onError: (e) => throw e,
        );
  }

  CollectionReference<Activity> _buildWithConverter() {
    return FirebaseFirestore.instance.collection(referenceString).withConverter(
          fromFirestore: (snapshot, _) => Activity.fromSnapshot(snapshot),
          toFirestore: (activity, _) => activity.toDocument(),
        );
  }
}
