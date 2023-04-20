import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/activity.dart';

class ActivityService {
  final String referenceString = 'activityList';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final CollectionReference collectionRef = firestore.collection('activityList');

  Stream<List<Activity>> activityList() {
    return _buildWithConverter().snapshots().map((event) => event.docs.map((e) => e.data()).toList());
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
}
