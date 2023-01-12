import 'package:get_it/get_it.dart';
import 'package:moodtracker/login/bloc/login_service.dart';

final getIt = GetIt.instance;

setupServices() {
  getIt.registerSingleton<LoginService>(LoginService());
}
