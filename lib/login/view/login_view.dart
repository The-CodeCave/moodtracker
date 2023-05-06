import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moodtracker/router/app_router.dart';
import '../../constants.dart';

import '../bloc/login_bloc.dart';
import '../widgets/widgets.dart';

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
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: defaultSpacerSize),
                            LoginForm(),
                            SizedBox(height: defaultSpacerSize),
                            LoginTypeSeperator(),
                            GoogleSignInButton(),
                            SizedBox(height: defaultSpacerSize),
                            AppleSignInButton(),
                            SizedBox(height: defaultSpacerSize),
                            PassKeySignInButton(),
                            SizedBox(height: !kIsWeb ? 2 : defaultSpacerSize),
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
                            ),
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
