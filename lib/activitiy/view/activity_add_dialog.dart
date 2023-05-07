import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moodtracker/activitiy/model/activity.dart';
import 'package:moodtracker/helper/view/cancel_button.dart';
import 'package:moodtracker/helper/view/save_button.dart';

import '../bloc/activity_add_dialog_bloc.dart';
import '../model/activity_category.dart';

class ActivityAddDialog extends StatelessWidget {
  final String title = 'Aktivität erstellen';
  final String info = 'Info';
  final String category = 'Kategorie';
  final String nameHint = 'Name';
  final String hoursHint = 'Stunden pro Woche';
  final String createText = 'Erstellen';
  final SizedBox _spacer = const SizedBox.square(dimension: 8.0);

  final TextEditingController nameController = TextEditingController(text: '');
  final TextEditingController hoursController = TextEditingController(text: '');

  ActivityAddDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ActivityAddDialogBloc, ActivityAddDialogState>(
      listener: (context, state) {
        if (state is ActivityAddDialogSuccessState) {
          GoRouter.of(context).pop(state.activity);
        }
      },
      builder: (context, state) {
        nameController.text = state.name ?? '';
        hoursController.text = state.hours ?? '';

        return AlertDialog(
          title: Text(title),
          actions: [
            CancelButton(),
            SaveButton(
              onPressed: () {
                context
                    .read<ActivityAddDialogBloc>()
                    .add(ActivityAddDialogCreateEvent(
                      name: nameController.text,
                      hours: hoursController.text,
                    ));
              },
              text: createText,
            ),
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildChildren(context, state),
          ),
        );
      },
    );
  }

  List<Widget> _buildChildren(
      BuildContext context, ActivityAddDialogState state) {
    String? nameError;
    String? hoursError;
    String? selectedSegmentsError;
    if (state is ActivityAddDialogErrorState) {
      nameError = state.nameError;
      hoursError = state.hoursError;
      selectedSegmentsError = state.selectedSegmentsError;
    }

    List<Widget> children = [
      Text(info),
      Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: nameHint,
              errorText: nameError,
              suffixIcon: _buildClearIcon(true, context),
            ),
          ),
          TextFormField(
            controller: hoursController,
            decoration: InputDecoration(
              hintText: hoursHint,
              errorText: hoursError,
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
          ),
          ButtonSegment(
            value: ActivityCategory.obligation.name,
            icon: Icon(Icons.home),
          ),
          ButtonSegment(
            value: ActivityCategory.hobby.name,
            icon: Icon(Icons.star),
          ),
        ],
        emptySelectionAllowed: true,
        selected: state.selectedSegments,
        onSelectionChanged: (p0) => context
            .read<ActivityAddDialogBloc>()
            .add(ActivityAddDialogChangedEvent(
              name: nameController.text,
              hours: hoursController.text,
              selectedSegments: p0,
            )),
      ),
    ];

    if (selectedSegmentsError != null) {
      Color? errorColor = Theme.of(context).colorScheme.error;
      TextStyle? style = Theme.of(context).textTheme.bodySmall;
      children
        ..add(_spacer)
        ..add(Text(
          selectedSegmentsError,
          style: style?.copyWith(color: errorColor),
        ));
    }

    return children;
  }

  _buildClearIcon(bool isName, BuildContext context) {
    return IconButton(
      onPressed: () {
        if (isName) {
          nameController.clear();
        } else {
          hoursController.clear();
        }
      },
      icon: Icon(Icons.clear),
    );
  }
}
