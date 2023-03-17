import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker/activitiy/view/activity_add_dialog.dart';
import 'package:moodtracker/activitiy/view/activity_list_tile.dart';

import '../bloc/activity_bloc.dart';
import '../model/activity.dart';

class ActivityListView extends StatelessWidget {
  final List<Activity> mockList = const [
    Activity(name: 'Volleyball', category: ActivityCategory.hobby, rating: ActivityRating.none),
    Activity(name: 'Klavier', category: ActivityCategory.hobby, rating: ActivityRating.neutral),
    Activity(name: 'Tanzen', category: ActivityCategory.hobby, rating: ActivityRating.none),
    Activity(name: 'Programmieren', category: ActivityCategory.work, rating: ActivityRating.good),
    Activity(name: 'Einkauf', category: ActivityCategory.obligation, rating: ActivityRating.neutral),
    Activity(name: 'Bügeln', category: ActivityCategory.obligation, rating: ActivityRating.bad),
  ];

  final String title = 'Aktivitäten';
  const ActivityListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const ActivityAddDialog();
                  });
              Activity a = Activity(
                id: '',
                name: 'Test',
                category: ActivityCategory.hobby,
                rating: ActivityRating.bad,
              );
              context.read<ActivityBloc>().add(ActivityAddEvent(a));
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.filter_list),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.send),
      ),
      body: ListView.builder(
        itemCount: mockList.length,
        itemBuilder: (context, index) => ActivityListTile(
          activity: mockList[index],
        ),
      ),
    );
  }
}
