import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker/app/bloc/app_bloc.dart';
import 'package:moodtracker/app/view/app_error_view.dart';
import 'package:moodtracker/router/app_router.dart';
import 'package:moodtracker/setup_services.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(),
      child: BlocConsumer<AppBloc, AppState>(
        listener: (context, state) {
          if (state is AppInitializedState) {
            context.read<AppBloc>().add(AppRegisterServicesEvent());
          }
        },
        builder: (context, state) {
          if (state is AppErrorState) {
            return const AppErrorView();
          }

          if (state.isInitialized && state.isServiceRegistered) {
            return MaterialApp.router(
              routerConfig: getIt.get<AppRouter>(),
              debugShowCheckedModeBanner: false,
              title: 'Moodtracker',
              theme: ThemeData(
                  textTheme: TextTheme(
                      headline3: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(0.0),
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF006590)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                    ),
                  )),
                  textSelectionTheme: TextSelectionThemeData(
                    cursorColor: Color(0xFF006590),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF006590)),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF42474C)),
                    ),
                    fillColor: Color(0xFFDEE3E9),
                    filled: true,
                    labelStyle: TextStyle(color: Color(0xFF006590)),
                    focusColor: Color(0xFF006590),
                  )),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
