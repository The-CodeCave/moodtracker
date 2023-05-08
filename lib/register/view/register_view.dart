import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:moodtracker/register/bloc/register_bloc.dart';

import '../../router/app_router.dart';

class RegisterView extends HookWidget {
  // TODO: fix this according to cleanings in login feature
  final double spacerHeight = 10;
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final username = useState<String?>(null);
    final usernamePasskey = useState<String?>(null);

    final password = useState<String?>(null);
    final hidePasswort = useState<bool>(true);
    return BlocProvider(
        create: (context) => RegisterBloc(),
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
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset("assets/login_logo_complete_alpha.png"),
                    )),
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(48),
                      topRight: Radius.circular(48),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF635A78),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
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
                            SizedBox(
                              height: 20,
                            ),
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
                                    hidePasswort.value ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
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
                                    child: BlocBuilder<RegisterBloc, RegisterState>(
                                      builder: (context, state) {
                                        return ElevatedButton(
                                          style: ButtonStyle(),
                                          onPressed: (username.value == null || password.value == null) || state is RegisterLoading
                                              ? null
                                              : () {
                                                  context.read<RegisterBloc>().add(
                                                        RegisterButtonPressed(
                                                          username: username.value!,
                                                          password: password.value!,
                                                        ),
                                                      );
                                                },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              state is RegisterLoading ? CircularProgressIndicator() : Icon(Icons.login),
                                              SizedBox(width: 10),
                                              Text("Registrieren"),
                                            ],
                                          ),
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
                                  child: Container(color: Colors.white, height: 1),
                                )),
                                Text(
                                  "oder",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(color: Colors.white, height: 1),
                                )),
                              ],
                            ),
                            SizedBox(height: spacerHeight),
                            TextFormField(
                              onChanged: (value) => usernamePasskey.value = value,
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
                            SizedBox(
                              height: 20,
                            ),
                            BlocBuilder<RegisterBloc, RegisterState>(
                              builder: (context, state) {
                                return MaterialButton(
                                  elevation: 0.0,
                                  onPressed: () async {
                                    if (usernamePasskey.value != null &&
                                        usernamePasskey.value!.isNotEmpty &&
                                        state is! RegisterLoadingPasskey) {
                                      context.read<RegisterBloc>().add(
                                            RegisterWithPasskey(
                                              username: usernamePasskey.value!,
                                            ),
                                          );
                                    }
                                  },
                                  height: 40,
                                  color: Colors.black,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: state is RegisterLoadingPasskey
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
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.key,
                                                color: Colors.white,
                                                size: 22,
                                              ),
                                              SizedBox(width: 15),
                                              Text(
                                                "Mit Passkey registrieren",
                                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                  ),
                                );
                              },
                            ),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Use TextButton instead of gesture detector, improves mouse hover for web?
                                  TextButton(
                                    style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.onTertiary),
                                    onPressed: () {
                                      context.go(AppRoutes.login);
                                    },
                                    child: Text('Einloggen'),
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
