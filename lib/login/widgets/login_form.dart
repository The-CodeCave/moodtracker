import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants.dart';

import '../bloc/login_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final String _emailLabel = 'E-Mail';
  final String _passwordLabel = 'Passwort';
  final String _loginLabel = 'Login';
  final CircularProgressIndicator _progressIndicator = const CircularProgressIndicator(strokeWidth: 2.0);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final Color errorFontColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        String? emailError;
        String? passwordError;
        TextStyle? errorStyle = Theme.of(context).textTheme.bodySmall?.copyWith(color: errorFontColor);

        if (state is LoginError) {
          emailError = state.emailError;
          passwordError = state.passwordError;
        }

        return Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: _emailLabel,
                errorText: emailError,
                errorStyle: errorStyle,
                filled: true,
                suffixIcon: ExcludeFocusTraversal(
                  child: IconButton(
                    onPressed: () => emailController.clear(),
                    icon: Icon(Icons.close),
                  ),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: defaultSpacerSize),
            TextFormField(
              controller: passwordController,
              obscureText: state.hidePassword,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: _passwordLabel,
                errorText: passwordError,
                errorStyle: errorStyle,
                filled: true,
                suffixIcon: IconButton(
                  onPressed: () {
                    context.read<LoginBloc>().add(LoginHidePasswordEvent());
                  },
                  icon: state.hidePassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                ),
              ),
            ),
            const SizedBox(height: defaultSpacerSize),
            SizedBox(
              height: loginButtonHeight,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(minimumSize: Size.fromHeight(loginButtonHeight)),
                onPressed: state is LoginLoading ? null : () => _login(context),
                icon: state is LoginLoading
                    ? SizedBox(
                        height: Theme.of(context).textTheme.labelLarge?.fontSize,
                        width: Theme.of(context).textTheme.labelLarge?.fontSize,
                        child: _progressIndicator,
                      )
                    : Icon(Icons.login),
                label: Text(_loginLabel),
              ),
            ),
          ],
        );
      },
    );
  }

  void _login(BuildContext context) {
    context.read<LoginBloc>().add(
          LoginButtonPressed(
            email: emailController.text,
            password: passwordController.text,
          ),
        );
  }
}
