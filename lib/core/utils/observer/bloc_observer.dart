import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_auth/core/utils/logger/logger_utils.dart';

/// A BlocObserver that logs the events, changes, transitions, errors, created, and closed events.
final class AppBlocObserver extends BlocObserver {
  AppBlocObserver({
    this.logEvents = true,
    this.logChanges = true,
    this.logTransitions = true,
    this.logErrors = true,
    this.logCreated = true,
    this.logClosed = true,
  });

  /// Whether to log the events.
  final bool logEvents;

  /// Whether to log the changes.
  final bool logChanges;

  /// Whether to log the transitions.
  final bool logTransitions;

  /// Whether to log the errors.
  final bool logErrors;

  /// Whether to log the created events.
  final bool logCreated;

  /// Whether to log the closed events.
  final bool logClosed;

  /// Log the event.
  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    if (logEvents) {
      LoggerUtils().logInfo('${bloc.runtimeType} $event');
    }
  }

  /// Log the change.
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (logChanges) {
      LoggerUtils().logInfo('${bloc.runtimeType} $change');
    }
  }

  /// Log the transition.
  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    if (logTransitions) {
      LoggerUtils().logInfo('${bloc.runtimeType} $transition');
    }
  }

  /// Log the error.
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    if (logErrors) {
      LoggerUtils().logError('${bloc.runtimeType} $error');
    }
  }

  /// Log the close.
  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    if (logClosed) {
      LoggerUtils().logInfo('${bloc.runtimeType} closed');
    }
  }

  /// Log the create.
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    if (logCreated) {
      LoggerUtils().logInfo('${bloc.runtimeType} created');
    }
  }
}
