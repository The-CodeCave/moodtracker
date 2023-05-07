import 'package:flutter/material.dart';
import 'package:moodtracker/login/model/login_provider.dart';

import 'social_login_button.dart';

class GoogleSignInButton extends StatelessWidget {
  final Color foregroundColor = const Color(0xFF757575);
  final Color backgroundColor = Colors.white;
  final String assetPath = 'assets/googlelogo.png';

  const GoogleSignInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SocialLoginButton(
      provider: LoginProvider.google,
      icon: Image.asset(
        assetPath,
        fit: BoxFit.fill,
      ),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }
}
