import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker/login/model/login_provider.dart';

import '../../constants.dart';
import '../bloc/login_bloc.dart';

class SocialLoginButton extends StatelessWidget {
  final String notImplemented = 'Social provider not implemented.';
  final double fontSize = loginButtonHeight * 0.43;

  final LoginProvider provider;
  final Widget icon;
  final Color foregroundColor;
  final Color backgroundColor;

  const SocialLoginButton({
    required this.provider,
    required this.icon,
    required this.foregroundColor,
    required this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return FilledButton(
          style: FilledButton.styleFrom(backgroundColor: backgroundColor),
          onPressed: () {
            switch (provider) {
              case LoginProvider.google:
                context.read<LoginBloc>().add(GoogleLoginButtonPressed());
                break;
              case LoginProvider.apple:
                context.read<LoginBloc>().add(AppleLoginButtonPressed());
                break;
              case LoginProvider.appleKeyPass:
                context.read<LoginBloc>().add(LoginWithPasskey());
                break;
              default:
                throw Exception(notImplemented);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(defaultSpacerSize),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox.square(
                  dimension: fontSize,
                  child: icon,
                ),
                SizedBox(width: defaultSpacerSize),
                Text(
                  provider.buttonText,
                  style: TextStyle(color: foregroundColor, fontSize: fontSize, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
