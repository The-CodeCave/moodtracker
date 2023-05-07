import 'package:flutter/material.dart';

class ForgotPasswordButton extends StatelessWidget {
  final String forgotPassword = 'Passwort vergessen?';
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
      child: Text(forgotPassword),
    );
  }
}
