import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_bloc.dart';

class LoginView extends HookWidget {
  final double spacerHeight = 10;

  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final username = useState<String?>(null);
    final password = useState<String?>(null);
    final hidePasswort = useState<bool>(true);
    return BlocProvider(
        create: (context) => LoginBloc(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFe9ddff),
                  Color(0xFF4f606e),
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: spacerHeight),
                Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child:
                          Image.asset("assets/login_logo_complete_alpha.png"),
                    )),
                Expanded(
                  flex: 6,
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
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, top: 30, bottom: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              onChanged: (value) => username.value = value,
                              decoration: InputDecoration(
                                labelText: "E-Mail",
                                // You can use filled: true with material color scheme
                                filled: true,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    // TODO: clear username here
                                  },
                                  icon: Icon(Icons.close),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: spacerHeight),
                            TextFormField(
                              onChanged: (value) => password.value = value,
                              obscureText: hidePasswort.value,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                labelText: "Passwort",
                                filled: true,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    hidePasswort.value = !hidePasswort.value;
                                  },
                                  icon: Icon(
                                    hidePasswort.value
                                        ? FontAwesomeIcons.eye
                                        : FontAwesomeIcons.eyeSlash,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: spacerHeight),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 40,
                                    child: BlocBuilder<LoginBloc, LoginState>(
                                      builder: (context, state) {
                                        // TODO: m3 use filled button instead of elevated button
                                        return FilledButton.icon(
                                          onPressed: (username.value == null || password.value == null) || state is LoginLoading
                                              ? null
                                              : () {
                                                  context.read<LoginBloc>().add(
                                                        LoginButtonPressed(
                                                          username:
                                                              username.value!,
                                                          password:
                                                              password.value!,
                                                        ),
                                                      );
                                                },
                                          icon: state is LoginLoading
                                              ? SizedBox(
                                                  height: Theme.of(context).textTheme.labelLarge?.fontSize,
                                                  width: Theme.of(context).textTheme.labelLarge?.fontSize,
                                                  child: CircularProgressIndicator(strokeWidth: 2.0),
                                                )
                                              : Icon(Icons.login),
                                          label: Text("Login"),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: spacerHeight),
                            Row(
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child:
                                      Container(color: Colors.white, height: 1),
                                )),
                                Text(
                                  // TODO: check this example, this way the labels are kept consistent through the app
                                  "oder",
                                  style: TextStyle(
                                    inherit: true,
                                    color: Theme.of(context).colorScheme.onTertiary,
                                  ),
                                  //style: Theme.of(context).textTheme.headline3,
                                ),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child:
                                      Container(color: Colors.white, height: 1),
                                )),
                              ],
                            ),
                            SizedBox(height: spacerHeight),
                            BlocBuilder<LoginBloc, LoginState>(
                              builder: (context, state) {
                                return MaterialButton(
                                  elevation: 0.0,
                                  onPressed: state is LoginLoading
                                      ? null
                                      : () async {
                                          context
                                              .read<LoginBloc>()
                                              .add(LoginWithPasskey());
                                        },
                                  height: 40,
                                  color: Colors.black,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.key,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          "Sign in with Passkey",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: !kIsWeb ? 2 : spacerHeight),
                            MaterialButton(
                              elevation: 0.0,
                              onPressed: () async {
                                //TODO: Implement Google Login
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
                                      style: TextStyle(
                                          color: Color(0xFF757575),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: !kIsWeb ? 2 : spacerHeight),
                            MaterialButton(
                              elevation: 0.0,
                              onPressed: () async {
                                //TODO: Implement Apple Login
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
                                    SizedBox(width: 15),
                                    Text(
                                      "Sign in with Apple",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Use TextButton instead of gesture detector, improves mouse hover for web?
                                  TextButton(
                                    style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.onTertiary),
                                    onPressed: () {
                                      //TODO: Implement Register
                                    },
                                    child: Text('Registrieren'),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.onTertiary),
                                    onPressed: () {
                                      //TODO: Implement Forgot Password
                                    },
                                    child: Text('Passwort vergessen?'),
                                  ),
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     //TODO: Implement Register
                                  //   },
                                  //   child: Text(
                                  //     "Registrieren",
                                  //     style: Theme.of(context).textTheme.headline3,
                                  //   ),
                                  // ),
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     //TODO: Implement Forgot Password
                                  //   },
                                  //   child: Text(
                                  //     "Passwort vergessen?",
                                  //     style: Theme.of(context).textTheme.headline3,
                                  //   ),
                                  // ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
