import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker/activitiy/model/activity.dart';
import 'package:moodtracker/helper/view/cancel_button.dart';
import 'package:moodtracker/helper/view/save_button.dart';

import '../bloc/activity_add_dialog_bloc.dart';

class ActivityAddDialog extends StatelessWidget {
  final String title = 'Aktivität erstellen';
  final String info = 'Info';
  final String category = 'Kategorie';
  final String nameHint = 'Name';
  final String hoursHint = 'Stunden';
  final SizedBox _spacer = const SizedBox.square(dimension: 8.0);

  final TextEditingController nameController = TextEditingController(text: '');
  final TextEditingController hoursController = TextEditingController(text: '');

  ActivityAddDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityAddDialogBloc, ActivityAddDialogState>(
      builder: (context, state) {
        nameController.text = state.name ?? '';
        hoursController.text = state.hours ?? '';

        return AlertDialog(
          title: Text(title),
          actions: [
            CancelButton(),
            SaveButton(
              onPressed: () {},
              text: 'Erstellen',
            ),
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(info),
              Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: nameHint,
                      suffixIcon: _buildClearIcon(true, context),
                    ),
                  ),
                  TextFormField(
                    controller: hoursController,
                    decoration: InputDecoration(
                      hintText: hoursHint,
                      suffixIcon: _buildClearIcon(false, context),
                    ),
                  ),
                ],
              ),
              _spacer,
              Text(category),
              _spacer,
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(
                    value: ActivityCategory.work.name,
                    icon: Icon(Icons.work),
                    label: Text(ActivityCategory.work.toDisplayName()),
                  ),
                  ButtonSegment(
                    value: ActivityCategory.obligation.name,
                    icon: Icon(Icons.home),
                    label: Text(ActivityCategory.obligation.toDisplayName()),
                  ),
                  ButtonSegment(
                    value: ActivityCategory.hobby.name,
                    icon: Icon(Icons.star),
                    label: Text(ActivityCategory.hobby.toDisplayName()),
                  ),
                ],
                emptySelectionAllowed: true,
                selected: state.selectedSegments,
                onSelectionChanged: (p0) => context.read<ActivityAddDialogBloc>().add(ActivityAddDialogSelectedSegmentsChangedEvent(p0)),
              ),
            ],
          ),
        );
      },
    );
  }

  _buildClearIcon(bool isName, BuildContext context) {
    return IconButton(
      onPressed: () {
        if (isName) {
          context.read<ActivityAddDialogBloc>().add(ActivityAddDialogNameChangedEvent(''));
        } else {
          context.read<ActivityAddDialogBloc>().add(ActivityAddDialogHoursChangedEvent(''));
        }
      },
      icon: Icon(Icons.clear),
    );
  }
}
