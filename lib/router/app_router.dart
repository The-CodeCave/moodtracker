import 'package:go_router/go_router.dart';
import 'package:moodtracker/app/view/app_error_view.dart';
import 'package:moodtracker/login/view/login_view.dart';

class AppRouter extends GoRouter {
  AppRouter()
      : super(
          routes: <GoRoute>[
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) {
                return const LoginView();
              },
            ),
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
  static String error = '/error';
}
