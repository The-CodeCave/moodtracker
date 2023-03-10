import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moodtracker/app/bloc/app_bloc.dart';
import 'package:moodtracker/register/bloc/register_bloc.dart';

class RegisterView extends HookWidget {
  final double spacerHeight = 10;
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final username = useState<String?>(null);
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
                      decoration: BoxDecoration(
                        color: Color(0xFF635A78),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, top: 30, bottom: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              onChanged: (value) => username.value = value,
                              decoration: InputDecoration(labelText: "E-Mail"),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            Divider(
                              height: 60,
                              color: Colors.white,
                              thickness: 1,
                            ),
                            TextFormField(
                              onChanged: (value) => password.value = value,
                              obscureText: hidePasswort.value,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                labelText: "Passwort",
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
                                    child: BlocBuilder<RegisterBloc,
                                        RegisterState>(
                                      builder: (context, state) {
                                        return ElevatedButton(
                                          style: ButtonStyle(),
                                          onPressed: (username.value == null ||
                                                      password.value == null) ||
                                                  state is RegisterLoading
                                              ? null
                                              : () {
                                                  context
                                                      .read<RegisterBloc>()
                                                      .add(
                                                        RegisterButtonPressed(
                                                          username:
                                                              username.value!,
                                                          password:
                                                              password.value!,
                                                        ),
                                                      );
                                                },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              state is RegisterLoading
                                                  ? CircularProgressIndicator()
                                                  : Icon(Icons.login),
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
                                  child:
                                      Container(color: Colors.white, height: 1),
                                )),
                                Text(
                                  "oder",
                                  style: Theme.of(context).textTheme.headline3,
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
                            BlocBuilder<RegisterBloc, RegisterState>(
                              builder: (context, state) {
                                return MaterialButton(
                                  elevation: 0.0,
                                  onPressed: state is RegisterLoading
                                      ? null
                                      : () async {
                                          if (username.value != null &&
                                              username.value!.isNotEmpty) {
                                            context.read<RegisterBloc>().add(
                                                  RegisterWithPasskey(
                                                    username: username.value!,
                                                  ),
                                                );
                                          }
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
                                          "Mit Passkey registrieren",
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
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      context
                                          .read<AppBloc>()
                                          .add(AppLoginButtonPressed());
                                    },
                                    child: Text(
                                      "Einloggen",
                                      style:
                                          Theme.of(context).textTheme.headline3,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      //TODO: Implement Forgot Password
                                    },
                                    child: Text(
                                      "Passwort vergessen?",
                                      style:
                                          Theme.of(context).textTheme.headline3,
                                    ),
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
