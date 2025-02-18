import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_supabase_auth/app/initializer/app_initializer.dart';
import 'package:flutter_supabase_auth/app/l10n/app_l10n.dart';
import 'package:flutter_supabase_auth/app/router/app_router.dart';
import 'package:flutter_supabase_auth/app/theme/cubit/theme_cubit.dart';
import 'package:flutter_supabase_auth/app/theme/dark/app_dark_theme.dart';
import 'package:flutter_supabase_auth/app/theme/light/app_light_theme.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/profile_event.dart';
import 'package:flutter_supabase_auth/locator.dart';

Future<void> main() async {
  await AppInitializer.init();

  runApp(
    EasyLocalization(
      path: AppL10n.path,
      supportedLocales: AppL10n.supportedLocales,
      fallbackLocale: AppL10n.en,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (context) => Locator.authBloc..add(AuthStateChangesEvent()),
          ),
          BlocProvider(
            lazy: false,
            create: (context) =>
                Locator.profileBloc..add(ProfileStateChangesEvent()),
          ),
          BlocProvider(
            create: (context) => ThemeCubit(),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp.router(
              title: 'DomainGo',
              debugShowCheckedModeBanner: false,
              routerConfig: AppRouter.router,
              // Localization
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              // Theme
              theme: AppLightTheme().themeData,
              darkTheme: AppDarkTheme().themeData,
              themeMode: themeState.themeMode,
            );
          },
        ),
      ),
    );
  }
}
