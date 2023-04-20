import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final Function()? onPressed;
  final String? text;
  const SaveButton({super.key, required this.onPressed, this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.check),
      label: Text(text ?? 'Speichern'),
    );
  }
}
