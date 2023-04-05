import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moodtracker/activitiy/model/activity.dart';
import 'package:moodtracker/activitiy/model/activity_filter.dart';

import '../bloc/activity_bloc.dart';

class ActivityFilterDialog extends HookWidget {
  ActivityBloc bloc;
  ActivityFilterDialog({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    final ActivityFilter? initialState = useMemoized(
      () {
        if (bloc.state is ActivityLoaded) {
          return (bloc.state as ActivityLoaded).filter;
        }
        return null;
      },
      [bloc.state],
    );

    final state = useState<ActivityFilter>(initialState ?? ActivityFilter());

    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Abbrechen'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            bloc.add(ActivityApplyFilterEvent(state.value));
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
                label: Text('Arbeit'),
                value: ActivityCategory.work.name,
              ),
              ButtonSegment(
                label: Text('Verpflichtung'),
                value: ActivityCategory.obligation.name,
              ),
              ButtonSegment(
                label: Text('Freizeit'),
                value: ActivityCategory.hobby.name,
              ),
            ],
            selected: {
              if (state.value.selectedCategory != null)
                state.value.selectedCategory!.name
            },
            onSelectionChanged: (p0) {
              if (p0.isEmpty) {
                state.value = state.value.copyWith(selectedCategory: null);
                return;
              }
              state.value = state.value.copyWith(
                  selectedCategory: ActivityCategory.values
                      .firstWhere((element) => element.name == p0.first));
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
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.clear),
            ),
            initialValue: state.value.nameFilter,
            onChanged: (value) {
              state.value = state.value.copyWith(nameFilter: value);
            },
          ),
        ],
      ),
    );
  }
}
