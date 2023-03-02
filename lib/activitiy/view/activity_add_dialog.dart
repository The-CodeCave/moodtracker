import 'package:flutter/material.dart';

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
    return Scaffold(
      body: AlertDialog(
        title: Text(title),
        content: Column(
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
                ButtonSegment(value: 'Arbeit'),
                ButtonSegment(value: 'Verpflichtung'),
                ButtonSegment(value: 'Freizeit'),
              ],
              selected: selectedSegments,
              onSelectionChanged: (p0) {
                setState(() {
                  selectedSegments = p0;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
