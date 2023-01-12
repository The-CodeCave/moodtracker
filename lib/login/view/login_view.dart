import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../bloc/login_bloc.dart';

class LoginView extends HookWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final username = useState<String?>(null);
    final password = useState<String?>(null);

    const double spacerHeight = 10;
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
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
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("../assets/login_logo_complete_alpha.png"),
              )),
              Expanded(
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
                      padding:
                          const EdgeInsets.only(left: 40, right: 40, top: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(labelText: "E-Mail"),
                            onChanged: (value) => username.value = value,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: spacerHeight),
                          TextFormField(
                            decoration: InputDecoration(labelText: "Passwort"),
                            obscureText: true,
                            onChanged: (value) => password.value = value,
                          ),
                          SizedBox(height: spacerHeight),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: BlocBuilder<LoginBloc, LoginState>(
                                    builder: (context, state) {
                                      return ElevatedButton(
                                        style: ButtonStyle(),
                                        onPressed: (username.value == null ||
                                                    password.value == null) ||
                                                state is LoginLoading
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
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            state is LoginLoading
                                                ? CircularProgressIndicator()
                                                : Icon(Icons.login),
                                            SizedBox(width: 10),
                                            Text("Login"),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
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
    );
  }
}
