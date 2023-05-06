import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../bloc/login_bloc.dart';

class PassKeySignInButton extends StatelessWidget {
  const PassKeySignInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return MaterialButton(
          elevation: 0.0,
          onPressed: () async {
            if (state is LoginLoadingPasskey) {
              return;
            }
            context.read<LoginBloc>().add(LoginWithPasskey());
          },
          height: 40,
          color: Colors.black,
          child: state is LoginLoadingPasskey
              ? Center(
                  child: SizedBox(
                    height: 38,
                    width: 38,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.key,
                        color: Colors.white,
                        size: 22,
                      ),
                      SizedBox(width: 15),
                      Text(
                        "Sign in with Passkey",
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
