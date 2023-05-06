import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants.dart';
import '../bloc/login_bloc.dart';

class AppleSignInButton extends StatelessWidget {
  const AppleSignInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return MaterialButton(
          elevation: 0.0,
          onPressed: () async {
            context.read<LoginBloc>().add(
                  AppleLoginButtonPressed(),
                );
          },
          height: 40,
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.apple,
                  color: Colors.white,
                  size: 22,
                ),
                SizedBox(height: defaultSpacerSize),
                Text(
                  "Sign in with Apple",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
