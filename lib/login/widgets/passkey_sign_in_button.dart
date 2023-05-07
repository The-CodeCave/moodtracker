import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moodtracker/constants.dart';

import '../bloc/login_bloc.dart';

class PassKeySignInButton extends StatelessWidget {
  final double fontSize = loginButtonHeight * 0.43;
  final double progressIndicatorStrokeWidth = 2;
  final Color fontColor = Colors.white;
  final Color buttonBackground = Colors.black;
  final String signIn = "Sign in with Passkey";

  const PassKeySignInButton({
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
            onPressed: () async {
              if (state is LoginLoadingPasskey) {
                return;
              }
              context.read<LoginBloc>().add(LoginWithPasskey());
            },
            child: state is LoginLoadingPasskey
                ? Center(
                    child: SizedBox(
                      height: fontSize,
                      width: fontSize,
                      child: CircularProgressIndicator(
                        strokeWidth: progressIndicatorStrokeWidth,
                        color: fontColor,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(defaultSpacerSize),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.key,
                          color: fontColor,
                          size: fontSize,
                        ),
                        SizedBox(width: defaultSpacerSize),
                        Text(
                          signIn,
                          style: TextStyle(color: fontColor, fontSize: fontSize, fontWeight: FontWeight.w500),
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
