import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker/activitiy/view/activity_add_dialog.dart';
import 'package:moodtracker/activitiy/view/activity_list_tile.dart';

import '../bloc/activity_add_dialog_bloc.dart';
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
            BlocBuilder<ActivityBloc, ActivityState>(
              builder: (context, state) {
                return IconButton(
                  onPressed: state is ActivityLoadingState
                      ? null
                      : () {
                          showDialog<Activity?>(
                            context: context,
                            builder: (context) {
                              return BlocProvider(
                                create: (context) => ActivityAddDialogBloc(),
                                child: ActivityAddDialog(),
                              );
                            },
                          ).then((value) {
                            if (value != null) {
                              // TODO: catch errors in bloc after this event and notify with listener and scaffold messenger
                              context.read<ActivityBloc>().add(ActivityAddEvent(value));
                            }
                          });
                        },
                  icon: Icon(Icons.add),
                );
              },
            ),
            BlocBuilder<ActivityBloc, ActivityState>(
              builder: (context, state) {
                Color? iconColor;
                if (state.filter?.isActive == true) {
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
