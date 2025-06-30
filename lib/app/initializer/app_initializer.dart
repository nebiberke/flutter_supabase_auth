import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/app/env/env.dart';
import 'package:flutter_supabase_auth/core/utils/logger/logger_utils.dart';
import 'package:flutter_supabase_auth/core/utils/observer/bloc_observer.dart';
import 'package:flutter_supabase_auth/locator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final class AppInitializer {
  const AppInitializer._();

  /// The primary entry point to initialize all essential app services and configurations.
  /// It follows a step-by-step structure for clarity and maintainability.
  static Future<void> init() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize or configure logger (if needed) before other services start.
      _initLogging();

      // Initialize core services such as Supabase, DI, and HydratedBloc.
      await _initCoreServices();

      // Initialize localization (EasyLocalization).
      await _initLocalization();

      // Set up a global Bloc observer to monitor state transitions and events.
      _initBlocObserver();
    } catch (e) {
      LoggerUtils().logError(e.toString());
      rethrow;
    }
  }

  /// Initializes or configures the logger or any other crash-reporting services.
  /// This step is usually performed before anything else so that it can capture
  /// logs or errors during the entire initialization process.
  static void _initLogging() {
    LoggerUtils().logInfo('Logger initialized.');
  }

  /// Initializes the core services required by the application:
  /// - Supabase: for database and authentication.
  /// - HydratedBloc: for state persistence.
  /// - Dependency Injection container (Locator).
  /// - Hive: for local storage.
  static Future<void> _initCoreServices() async {
    // Initialize Supabase.
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
    );

    // Initialize HydratedBloc for persistent state management.
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(
        (await getTemporaryDirectory()).path,
      ),
    );

    // Initialize dependency injection (Service Locator).
    Locator.setupLocator(supabase: Supabase.instance.client);
  }

  /// Initializes and configures the localization framework (EasyLocalization).
  /// This ensures that localization is ready before the app widgets load.
  static Future<void> _initLocalization() async {
    await EasyLocalization.ensureInitialized();
  }

  /// Sets up a global BlocObserver to monitor BLoC state transitions and events.
  /// This observer helps in logging or debugging changes across all BLoCs in the app.
  static void _initBlocObserver() {
    Bloc.observer = AppBlocObserver(logEvents: false, logTransitions: false);
  }
}
