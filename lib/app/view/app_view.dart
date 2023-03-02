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
              theme: _buildTheme(context),
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

  // TODO: incroproate the official material theme?
  // This way all colors will be set for dialogs, appbars, cards, containers and so on
  // There will be only a few things left to fix manually
  ThemeData _buildTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFF006590),
        onPrimary: Color(0xFFFFFFFF),
        primaryContainer: Color(0xFFC8E6FF),
        onPrimaryContainer: Color(0xFF001E2E),
        secondary: Color(0xFF52606C),
        onSecondary: Color(0xFFFFFFFF),
        secondaryContainer: Color(0xFFD5E4F2),
        onSecondaryContainer: Color(0xFF0F1D27),
        tertiary: Color(0xFF635A78),
        onTertiary: Color(0xFFFFFFFF),
        tertiaryContainer: Color(0xFFE9DDFF),
        onTertiaryContainer: Color(0xFF1F1731),
        error: Color(0xFFBA1A1A),
        onError: Color(0xFFFFFFFF),
        errorContainer: Color(0xFFFFDAD6),
        onErrorContainer: Color(0xFF410002),
        background: Color(0xFFFCFCFE),
        onBackground: Color(0xFF1A1C1E),
        surface: Color(0xFFFCFCFE),
        onSurface: Color(0xFF1A1C1E),
        surfaceVariant: Color(0xFFDEE3E9),
        onSurfaceVariant: Color(0xFF42474C),
        outline: Color(0xFF72787D),
        outlineVariant: Color(0xFFCAC4D0),
      ),
      useMaterial3: true,
    );
  }
}
