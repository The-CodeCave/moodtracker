import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker/app/bloc/app_bloc.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        String text = 'Unknown Error';
        if (state is AppErrorState) {
          text = state.message ?? text;
        }

        return Center(
          child: Text(text),
        );
      },
    );
  }
}
