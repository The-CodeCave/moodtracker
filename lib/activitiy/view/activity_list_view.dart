import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker/activitiy/view/activity_add_dialog.dart';
import 'package:moodtracker/activitiy/view/activity_list_tile.dart';

import '../bloc/activity_bloc.dart';
import 'activity_filter_dialog.dart';

class ActivityListView extends StatelessWidget {
  final String title = 'Aktivitäten';
  const ActivityListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const ActivityAddDialog();
                    });
                // TODO: adapt this to dialog result
                // Activity a = Activity(
                //   id: '',
                //   name: 'Test',
                //   category: ActivityCategory.hobby,
                //   rating: ActivityRating.bad,
                // );
                // context.read<ActivityBloc>().add(ActivityAddEvent(a));
              },
              icon: Icon(Icons.add),
            ),
            BlocBuilder<ActivityBloc, ActivityState>(
              builder: (context, state) {
                Color? iconColor;
                if (state.filter != null) {
                  iconColor = Theme.of(context).colorScheme.inversePrimary;
                }
                return IconButton(
                  onPressed: state is ActivityLoadingState
                      ? null
                      : () {
                          final ActivityBloc bloc = context.read<ActivityBloc>();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return BlocProvider.value(
                                value: bloc,
                                child: ActivityFilterDialog(),
                              );
                            },
                          );
                        },
                  icon: Icon(
                    Icons.filter_list,
                    color: iconColor,
                  ),
                );
              },
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
            if (state is ActivityLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ActivityListUpdatedState) {
              return ListView.builder(
                itemCount: state.filteredList.length,
                itemBuilder: (context, index) {
                  return ActivityListTile(activity: state.filteredList[index]);
                },
              );
            } else {
              return const Center(child: Text('Error'));
            }
          },
        ));
  }
}
