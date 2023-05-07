import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moodtracker/router/app_router.dart';
import '../../constants.dart';

import '../bloc/login_bloc.dart';
import '../widgets/widgets.dart';

class LoginView extends HookWidget {
  final BorderRadius clipBorderRadius = const BorderRadius.only(topLeft: Radius.circular(48), topRight: Radius.circular(48));
  final Color gradientBegin = const Color(0xFFe9ddff);
  final Color gradientEnd = const Color(0xFF4f606e);
  final EdgeInsets logoPadding = const EdgeInsets.all(20.0);
  final EdgeInsets formPadding = const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: defaultSpacerSize);
  final int logoFlex = 1;
  final int loginFormFlex = 2;

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
                  flex: logoFlex,
                  child: Padding(
                    padding: logoPadding,
                    child: Image.asset(logoAssetPath),
                  ),
                ),
                ClipRRect(
                  borderRadius: clipBorderRadius,
                  child: Container(
                    color: Theme.of(context).colorScheme.tertiary,
                    child: Padding(
                      padding: formPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: defaultSpacerSize),
                          LoginForm(),
                          const SizedBox(height: defaultSpacerSize),
                          LoginTypeSeperator(),
                          const SizedBox(height: defaultSpacerSize),
                          GoogleSignInButton(),
                          const SizedBox(height: defaultSpacerSize),
                          AppleSignInButton(),
                          const SizedBox(height: defaultSpacerSize),
                          PassKeySignInButton(),
                          const SizedBox(height: defaultSpacerSize),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RegisterButton(),
                              ForgotPasswordButton(),
                            ],
                          ),
                        ],
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
