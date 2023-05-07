import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker/helper/view/loading_icon.dart';
import 'package:moodtracker/login/model/login_provider.dart';

import '../../constants.dart';
import '../bloc/login_bloc.dart';

class SocialLoginButton extends StatelessWidget {
  final String notImplemented = 'Social provider not implemented.';
  final double fontSize = loginButtonHeight * 0.43;

  final LoginProvider provider;
  final Widget icon;
  final Color foregroundColor;
  final Color backgroundColor;

  const SocialLoginButton({
    required this.provider,
    required this.icon,
    required this.foregroundColor,
    required this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        bool isLoading = _initIsLoading(state);

        return FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: backgroundColor,
            minimumSize: Size.fromHeight(loginButtonHeight),
          ),
          onPressed: isLoading ? null : () => _onPressed(context),
          icon: LoadingIcon(
            icon: isLoading ? null : SizedBox.square(dimension: fontSize, child: icon),
            color: foregroundColor,
            size: fontSize,
          ),
          label: Text(
            provider.buttonText,
            style: TextStyle(color: foregroundColor, fontSize: fontSize, fontWeight: FontWeight.w500),
          ),
        );
      },
    );
  }

  bool _initIsLoading(LoginState state) {
    if (state is LoginLoadingGoogle && provider == LoginProvider.google) {
      return true;
    } else if (state is LoginLoadingApple && provider == LoginProvider.apple) {
      return true;
    } else if (state is LoginLoadingPasskey && provider == LoginProvider.applePasskey) {
      return true;
    }
    return false;
  }

  void _onPressed(BuildContext context) {
    switch (provider) {
      case LoginProvider.google:
        context.read<LoginBloc>().add(GoogleLoginButtonPressed(isWeb: kIsWeb));
        break;
      case LoginProvider.apple:
        context.read<LoginBloc>().add(AppleLoginButtonPressed(isWeb: kIsWeb));
        break;
      case LoginProvider.applePasskey:
        context.read<LoginBloc>().add(LoginWithPasskey());
        break;
      default:
        throw Exception(notImplemented);
    }
  }
}
