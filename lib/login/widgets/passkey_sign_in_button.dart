import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moodtracker/constants.dart';

import '../model/login_provider.dart';
import 'social_login_button.dart';

class PassKeySignInButton extends StatelessWidget {
  final double fontSize = loginButtonHeight * 0.43;
  final double progressIndicatorStrokeWidth = 2;
  final Color foregroundColor = Colors.white;
  final Color backgroundColor = Colors.black;
  final String signIn = "Sign in with Passkey";

  const PassKeySignInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SocialLoginButton(
      provider: LoginProvider.applePasskey,
      icon: Icon(
        FontAwesomeIcons.key,
        color: foregroundColor,
        size: fontSize,
      ),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }
}
