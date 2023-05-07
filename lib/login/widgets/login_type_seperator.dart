import 'package:flutter/material.dart';

class LoginTypeSeperator extends StatelessWidget {
  final String loginSeperatorText = 'oder';

  const LoginTypeSeperator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const LoginSeperatorLine(),
        Text(
          loginSeperatorText,
          style: TextStyle(
            inherit: true,
            color: Theme.of(context).colorScheme.onTertiary,
          ),
        ),
        const LoginSeperatorLine(),
      ],
    );
  }
}

class LoginSeperatorLine extends StatelessWidget {
  final EdgeInsets defaultPadding = const EdgeInsets.all(15.0);
  final Color lineColor = Colors.white;
  final double lineHeight = 1.0;

  const LoginSeperatorLine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: defaultPadding,
      child: Container(color: Colors.white, height: 1),
    ));
  }
}
