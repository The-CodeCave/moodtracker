import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/app_router.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.onTertiary),
      onPressed: () {
        context.go(AppRoutes.register);
      },
      child: Text('Registrieren'),
    );
  }
}
