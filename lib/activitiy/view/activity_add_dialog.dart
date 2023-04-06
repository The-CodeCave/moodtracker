import 'package:flutter/material.dart';
import 'package:moodtracker/activitiy/model/activity.dart';

class ActivityAddDialog extends StatefulWidget {
  const ActivityAddDialog({super.key});

  @override
  State<ActivityAddDialog> createState() => _ActivityAddDialogState();
}

class _ActivityAddDialogState extends State<ActivityAddDialog> {
  final String title = 'Aktivität erstellen';
  final String info = 'Info';
  final String category = 'Kategorie';
  final String nameHint = 'Name';
  final String hoursHint = 'Name';

  Set<String> selectedSegments = {};

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(info),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: nameHint,
                    suffixIcon: Icon(Icons.clear),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: hoursHint,
                    suffixIcon: Icon(Icons.clear),
                  ),
                ),
              ],
            ),
          ),
          Text(category),
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
            selected: selectedSegments,
            onSelectionChanged: (p0) {
              setState(() {
                selectedSegments = p0;
              });
            },
          ),
        ],
      ),
    );
  }
}
