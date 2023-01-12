import 'package:get_it/get_it.dart';
import 'package:moodtracker/login/bloc/login_service.dart';
import 'package:moodtracker/router/app_router.dart';

final getIt = GetIt.instance;

setupServices() {
  getIt.registerSingleton<LoginService>(LoginService());
  getIt.registerSingleton<AppRouter>(AppRouter());
}
