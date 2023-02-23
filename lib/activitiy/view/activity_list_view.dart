import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/activity_bloc.dart';
import '../model/activity.dart';

class ActivityListView extends StatelessWidget {
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
              Activity a = Activity(id: '', name: 'Test');
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
        child: Icon(Icons.check),
      ),
      body: Placeholder(),
    );
  }
}
