import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moodtracker/app/view/app_error_view.dart';
import 'package:moodtracker/login/bloc/login_service.dart';
import 'package:moodtracker/login/view/auth_view.dart';
import 'package:moodtracker/login/view/login_view.dart';
import 'package:moodtracker/setup_services.dart';

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
                  return const AuthView(child: Text("Home: Not implemented yet."));
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
  static String login = '/login';
  static String home = '/';
  static String error = '/error';
}
