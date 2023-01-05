import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker/app/bloc/app_bloc.dart';
import 'package:moodtracker/app/view/app_error_view.dart';
import 'package:moodtracker/router/app_router.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(),
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          if (state is AppErrorState) {
            return const AppErrorView();
          }

          if (state.isInitialized) {
            return MaterialApp.router(
              routerConfig: AppRouter(),
              debugShowCheckedModeBanner: false,
              title: 'Moodtracker',
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
