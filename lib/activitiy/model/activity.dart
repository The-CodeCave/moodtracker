import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String id;
  final String name;
  const Activity({required this.id, required this.name});

  factory Activity.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Activity(
      id: snapshot.id,
      name: snapshot['name'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
    };
  }
}
