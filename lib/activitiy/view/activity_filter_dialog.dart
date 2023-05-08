import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moodtracker/activitiy/model/activity_filter.dart';

import '../bloc/activity_bloc.dart';
import '../model/activity_category.dart';

class ActivityFilterDialog extends HookWidget {
  const ActivityFilterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        Set<String> selected = {};
        ActivityCategory? category = state.filter?.selectedCategory;
        if (category != null) {
          selected.add(category.name);
        }

        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () {
                context.read<ActivityBloc>().add(ActivityApplyFilterEvent(filter: null));
                Navigator.pop(context);
              },
              child: Text('Zurücksetzen'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Anwenden'),
            ),
          ],
          title: Text('Filter'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kategorie',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                height: 15,
              ),
              SegmentedButton<String>(
                emptySelectionAllowed: true,
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    label: Icon(Icons.work),
                    value: ActivityCategory.work.name,
                  ),
                  ButtonSegment(
                    label: Icon(Icons.home),
                    value: ActivityCategory.obligation.name,
                  ),
                  ButtonSegment(
                    label: Icon(Icons.star),
                    value: ActivityCategory.hobby.name,
                  ),
                ],
                selected: selected,
                onSelectionChanged: (p0) {
                  ActivityFilter? filter;
                  if (p0.isEmpty) {
                    filter = state.filter?.copyWith(selectedCategory: null);
                  } else {
                    ActivityCategory category = ActivityCategory.values.firstWhere((element) => element.name == p0.first);
                    filter = state.filter?.copyWith(selectedCategory: category) ?? ActivityFilter(selectedCategory: category);
                  }
                  context.read<ActivityBloc>().add(ActivityApplyFilterEvent(filter: filter));
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Name",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                initialValue: state.filter?.nameFilter,
                onChanged: (value) {
                  ActivityFilter? filter;
                  if (value.isEmpty) {
                    filter = state.filter?.copyWith(nameFilter: null);
                  } else {
                    filter = state.filter?.copyWith(nameFilter: value) ?? ActivityFilter(nameFilter: value);
                  }
                  context.read<ActivityBloc>().add(ActivityApplyFilterEvent(filter: filter));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
