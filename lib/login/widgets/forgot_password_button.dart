import 'package:flutter/material.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onTertiary,
      ),
      onPressed: () {
        //TODO: Implement Forgot Password
      },
      child: Text('Passwort vergessen?'),
    );
  }
}
