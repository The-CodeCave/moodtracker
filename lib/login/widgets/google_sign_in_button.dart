import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';
import '../bloc/login_bloc.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
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
                  GoogleLoginButtonPressed(),
                );
          },
          height: 40,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/googlelogo.png',
                  height: 22,
                ),
                SizedBox(width: defaultSpacerSize),
                Text(
                  "Sign in with Google",
                  style: TextStyle(color: Color(0xFF757575), fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
