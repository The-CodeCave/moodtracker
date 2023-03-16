import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moodtracker/resetPassword/bloc/reset_password_bloc.dart';

class ResetPasswordView extends HookWidget {
  final double spacerHeight = 10;
  @override
  Widget build(BuildContext context) {
    final username = useState<String>("");
    final emailcontroller = useTextEditingController();
    return BlocProvider(
        create: (context) => ResetPasswordBloc(),
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
                    child: Image.asset("assets/login_logo_complete_alpha.png"),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(48),
                      topRight: Radius.circular(48),
                    ),
                    child: Container(
                      color: Theme.of(context).colorScheme.tertiary,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, top: 30, bottom: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Gebe die E-Mail Adresse deines Kontos ein, um eine Anleitung zum Zurücksetzten deines Passwortes zu erhalten.",
                              style: TextStyle(
                                inherit: true,
                                color: Theme.of(context).colorScheme.onTertiary,
                              ),
                              //style: Theme.of(context).textTheme.headline3,
                            ),
                            SizedBox(height: spacerHeight),
                            TextFormField(
                              onChanged: (value) => username.value = value,
                              controller: emailcontroller,
                              decoration: InputDecoration(
                                labelText: "E-Mail",
                                filled: true,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    username.value = "";
                                    emailcontroller.clear();
                                  },
                                  icon: Icon(Icons.close),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            Expanded(child: Container()),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 40,
                                    child: BlocBuilder<ResetPasswordBloc,
                                        ResetPasswordState>(
                                      builder: (context, state) {
                                        return FilledButton.icon(
                                          onPressed: username.value == "" ||
                                                  state is ResetPasswordLoading
                                              ? null
                                              : () {
                                                  context
                                                      .read<ResetPasswordBloc>()
                                                      .add(
                                                          ResetPasswordButtonPressed(
                                                              email: username
                                                                  .value));
                                                },
                                          icon: state is ResetPasswordLoading
                                              ? SizedBox(
                                                  height: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge
                                                      ?.fontSize,
                                                  width: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge
                                                      ?.fontSize,
                                                  child:
                                                      CircularProgressIndicator(
                                                          strokeWidth: 2.0),
                                                )
                                              : Icon(Icons.send),
                                          label: Text("Passwort zurücksetzen"),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: spacerHeight),
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
