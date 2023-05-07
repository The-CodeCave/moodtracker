import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';
import '../bloc/login_bloc.dart';

class GoogleSignInButton extends StatelessWidget {
  final double fontSize = loginButtonHeight * 0.43;
  final Color fontColor = const Color(0xFF757575);
  final Color buttonBackground = Colors.white;
  final String signIn = 'Sign in with Google';
  final String assetPath = 'assets/googlelogo.png';

  const GoogleSignInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return FilledButton(
          style: FilledButton.styleFrom(backgroundColor: buttonBackground),
          onPressed: () async {
            context.read<LoginBloc>().add(
                  GoogleLoginButtonPressed(),
                );
          },
          child: Padding(
            padding: const EdgeInsets.all(defaultSpacerSize),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox.square(
                  dimension: fontSize,
                  child: Image.asset(
                    assetPath,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(width: defaultSpacerSize),
                Text(
                  signIn,
                  style: TextStyle(color: fontColor, fontSize: fontSize, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
