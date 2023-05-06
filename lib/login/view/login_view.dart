import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moodtracker/router/app_router.dart';
import '../../constants.dart';

import '../bloc/login_bloc.dart';
import 'login_form.dart';

class LoginView extends HookWidget {
  final Color gradientBegin = const Color(0xFFe9ddff);
  final Color gradientEnd = const Color(0xFF4f606e);

  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                gradientBegin,
                gradientEnd,
              ],
            ),
          ),
          child: BlocListener<LoginBloc, LoginState>(
            listenWhen: (previous, current) => current is LoginSuccess,
            listener: (context, state) {
              GoRouter.of(context).go(AppRoutes.home);
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image.asset(logoAssetPath),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(48),
                      topRight: Radius.circular(48),
                    ),
                    child: Container(
                      color: Theme.of(context).colorScheme.tertiary,
                      // decoration: BoxDecoration(
                      //   color: Color(0xFF635A78),
                      // ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: defaultSpacerHeight),
                            LoginForm(),
                            SizedBox(height: defaultSpacerHeight),
                            Row(
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(color: Colors.white, height: 1),
                                )),
                                Text(
                                  "oder",
                                  style: TextStyle(
                                    inherit: true,
                                    color: Theme.of(context).colorScheme.onTertiary,
                                  ),
                                ),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(color: Colors.white, height: 1),
                                )),
                              ],
                            ),
                            BlocBuilder<LoginBloc, LoginState>(
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
                                        SizedBox(width: 15),
                                        Text(
                                          "Sign in with Google",
                                          style: TextStyle(color: Color(0xFF757575), fontSize: 14, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: defaultSpacerHeight),
                            BlocBuilder<LoginBloc, LoginState>(
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
                                        SizedBox(height: defaultSpacerHeight),
                                        Text(
                                          "Sign in with Apple",
                                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: defaultSpacerHeight),
                            BlocBuilder<LoginBloc, LoginState>(
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
                            ),
                            SizedBox(height: !kIsWeb ? 2 : defaultSpacerHeight),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Use TextButton instead of gesture detector, improves mouse hover for web?
                                TextButton(
                                  style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.onTertiary),
                                  onPressed: () {
                                    context.go(AppRoutes.register);
                                  },
                                  child: Text('Registrieren'),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Theme.of(context).colorScheme.onTertiary,
                                  ),
                                  onPressed: () {
                                    //TODO: Implement Forgot Password
                                  },
                                  child: Text('Passwort vergessen?'),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
