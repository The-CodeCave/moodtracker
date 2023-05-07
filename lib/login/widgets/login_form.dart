import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../constants.dart';

import '../bloc/login_bloc.dart';

class LoginForm extends HookWidget {
  LoginForm({
    super.key,
  });

  final String _emailLabel = 'E-Mail';
  final String _passwordLabel = 'Passwort';
  final String _loginLabel = 'Login';
  final CircularProgressIndicator _progressIndicator = const CircularProgressIndicator(strokeWidth: 2.0);
  final _email = useState<String?>(null);
  final _password = useState<String?>(null);
  final _hidePasswort = useState<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          onChanged: (value) => _email.value = value,
          decoration: InputDecoration(
            labelText: _emailLabel,
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
        const SizedBox(height: defaultSpacerSize),
        TextFormField(
          onChanged: (value) => _password.value = value,
          obscureText: _hidePasswort.value,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            labelText: _passwordLabel,
            filled: true,
            suffixIcon: IconButton(
              onPressed: () {
                _hidePasswort.value = !_hidePasswort.value;
              },
              icon: _hidePasswort.value ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
            ),
          ),
        ),
        const SizedBox(height: defaultSpacerSize),
        BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return SizedBox(
              height: loginButtonHeight,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(minimumSize: Size.fromHeight(loginButtonHeight)),
                onPressed: _email.value == null || _password.value == null || state is LoginLoading ? null : () => _login(context),
                icon: state is LoginLoading
                    ? SizedBox(
                        height: Theme.of(context).textTheme.labelLarge?.fontSize,
                        width: Theme.of(context).textTheme.labelLarge?.fontSize,
                        child: _progressIndicator,
                      )
                    : Icon(Icons.login),
                label: Text(_loginLabel),
              ),
            );
          },
        ),
      ],
    );
  }

  void _login(BuildContext context) {
    context.read<LoginBloc>().add(
          LoginButtonPressed(
            username: _email.value!,
            password: _password.value!,
          ),
        );
  }
}
