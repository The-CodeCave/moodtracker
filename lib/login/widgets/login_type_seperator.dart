import 'package:flutter/material.dart';

class LoginTypeSeperator extends StatelessWidget {
  const LoginTypeSeperator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(color: Colors.white, height: 1),
        )),
        Text(
          "oder",
          style: TextStyle(
            inherit: true,
            color: Theme.of(context).colorScheme.onTertiary,
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(color: Colors.white, height: 1),
        )),
      ],
    );
  }
}
