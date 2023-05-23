import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_passkeys/flutter_passkeys.dart';
import 'package:get_it/get_it.dart';
import 'package:moodtracker/login/service/login_service.dart';
import 'package:moodtracker/register/bloc/register_service.dart';
import 'package:moodtracker/router/app_router.dart';

final getIt = GetIt.instance;

setupServices() {
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  getIt.registerSingleton<RegisterService>(RegisterService());
  getIt.registerSingleton<LoginService>(LoginService());
  getIt.registerSingleton<AppRouter>(AppRouter());
  getIt.registerSingleton<FlutterPasskeys>(FlutterPasskeys());
}
