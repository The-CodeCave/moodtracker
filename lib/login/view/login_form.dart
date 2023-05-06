import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../constants.dart';

import '../bloc/login_bloc.dart';

class LoginForm extends HookWidget {
  LoginForm({
    super.key,
  });

  final String emailLabel = 'E-Mail';
  final String passwordLabel = 'Passwort';
  final String loginLabel = 'Login';
  final email = useState<String?>(null);
  final password = useState<String?>(null);
  final hidePasswort = useState<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          onChanged: (value) => email.value = value,
          decoration: InputDecoration(
            labelText: emailLabel,
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
        SizedBox(height: defaultSpacerHeight),
        TextFormField(
          onChanged: (value) => password.value = value,
          obscureText: hidePasswort.value,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            labelText: passwordLabel,
            filled: true,
            suffixIcon: IconButton(
              onPressed: () {
                hidePasswort.value = !hidePasswort.value;
              },
              icon: hidePasswort.value ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
            ),
          ),
        ),
        SizedBox(height: defaultSpacerHeight),
        BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return FilledButton.icon(
              style: FilledButton.styleFrom(minimumSize: Size.fromHeight(minButtonHeight)),
              onPressed: email.value == null || password.value == null || state is LoginLoading ? null : () => _login(context),
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
      ],
    );
  }

  void _login(BuildContext context) {
    context.read<LoginBloc>().add(
          LoginButtonPressed(
            username: email.value!,
            password: password.value!,
          ),
        );
  }
}
