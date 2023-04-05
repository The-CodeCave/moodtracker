import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker/activitiy/view/activity_add_dialog.dart';
import 'package:moodtracker/activitiy/view/activity_list_tile.dart';

import '../bloc/activity_bloc.dart';
import '../model/activity.dart';
import 'activity_filter_dialog.dart';

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
              onPressed: () {
                final bloc = context.read<ActivityBloc>();
                showDialog(
                  context: context,
                  builder: (_) {
                    return BlocProvider.value(
                      value: bloc,
                      child: ActivityFilterDialog(),
                    );
                  },
                );
              },
              icon: Icon(Icons.filter_list),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.send),
        ),
        body: BlocBuilder(
          bloc: context.read<ActivityBloc>(),
          builder: (context, state) {
            if (state is ActivityInitial || state is ActivityLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ActivityLoaded) {
              return ListView.builder(
                itemCount: state.activities.length,
                itemBuilder: (context, index) {
                  return ActivityListTile(activity: state.activities[index]);
                },
              );
            } else {
              return const Center(child: Text('Error'));
            }
          },
        ));
  }
}
