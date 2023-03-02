import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moodtracker/activitiy/view/activity_list_view.dart';
import 'package:moodtracker/app/view/app_error_view.dart';
import 'package:moodtracker/login/bloc/login_service.dart';
import 'package:moodtracker/login/view/auth_view.dart';
import 'package:moodtracker/login/view/login_view.dart';
import 'package:moodtracker/setup_services.dart';

import '../activitiy/bloc/activity_bloc.dart';

class AppRouter extends GoRouter {
  AppRouter()
      : super(
          redirect: (context, state) {
            if (getIt.get<LoginService>().getUser() == null) {
              return AppRoutes.login;
            }
            return Future.value();
          },
          routes: <GoRoute>[
            GoRoute(
              path: AppRoutes.login,
              builder: (context, state) {
                return const LoginView();
              },
            ),
            GoRoute(
                path: AppRoutes.home,
                builder: (context, state) {
                  return AuthView(
                      child: BlocProvider(
                    create: (context) => ActivityBloc(),
                    child: ActivityListView(),
                  ));
                }),
            GoRoute(
              path: AppRoutes.error,
              builder: (context, state) {
                return const AppErrorView();
              },
            ),
          ],
        );
}

class AppRoutes {
  static String home = '/';
  static String login = '/login';
  static String error = '/error';
}
