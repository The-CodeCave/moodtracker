import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moodtracker/login/widgets/social_login_button.dart';

import '../../constants.dart';
import '../model/login_provider.dart';

class AppleSignInButton extends StatelessWidget {
  // Font size should be 43% of button height according to apple design guidelines
  // https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple#Creating-a-custom-Sign-in-with-Apple-button
  final double fontSize = loginButtonHeight * 0.43;
  final Color foregroundColor = Colors.white;
  final Color backgroundColor = Colors.black;
  final String signIn = 'Sign in with Apple';

  const AppleSignInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SocialLoginButton(
      provider: LoginProvider.apple,
      icon: Icon(
        FontAwesomeIcons.apple,
        color: foregroundColor,
        size: fontSize,
      ),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }
}
