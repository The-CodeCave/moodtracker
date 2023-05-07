import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants.dart';
import '../bloc/login_bloc.dart';

class AppleSignInButton extends StatelessWidget {
  // Font size should be 43% of button height according to apple design guidelines
  // https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple#Creating-a-custom-Sign-in-with-Apple-button
  final double fontSize = loginButtonHeight * 0.43;
  final Color fontColor = Colors.white;
  final Color buttonBackground = Colors.black;
  final String signIn = 'Sign in with Apple';

  const AppleSignInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return SizedBox(
          height: loginButtonHeight,
          child: FilledButton(
            style: FilledButton.styleFrom(backgroundColor: buttonBackground),
            onPressed: () {
              context.read<LoginBloc>().add(AppleLoginButtonPressed());
            },
            child: Padding(
              padding: const EdgeInsets.all(defaultSpacerSize),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.apple,
                    color: fontColor,
                    size: fontSize,
                  ),
                  SizedBox(width: defaultSpacerSize),
                  Text(
                    signIn,
                    style: TextStyle(
                      color: fontColor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
