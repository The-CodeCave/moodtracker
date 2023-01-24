import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moodtracker/router/app_router.dart';

import '../../app/bloc/app_bloc.dart';

class AuthView extends StatelessWidget {
  final Widget child;
  const AuthView({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listenWhen: (previous, current) => current is AppUserUnauthenticatedState,
      listener: (context, state) {
        GoRouter.of(context).go(AppRoutes.login);
      },
      child: child,
    );
  }
}
