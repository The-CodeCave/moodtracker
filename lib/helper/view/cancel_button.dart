import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: () {
          GoRouter.of(context).pop();
        },
        icon: const Icon(Icons.cancel),
        label: const Text('Abbrechen'));
  }
}
