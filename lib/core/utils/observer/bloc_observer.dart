import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_auth/core/utils/logger/logger_utils.dart';

final class AppBlocObserver extends BlocObserver {
  AppBlocObserver({
    this.logEvents = true,
    this.logChanges = true,
    this.logTransitions = true,
    this.logErrors = true,
    this.logCreated = true,
    this.logClosed = true,
  });

  final bool logEvents;
  final bool logChanges;
  final bool logTransitions;
  final bool logErrors;
  final bool logCreated;
  final bool logClosed;

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    if (logEvents) {
      LoggerUtils().logInfo('${bloc.runtimeType} $event');
    }
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (logChanges) {
      LoggerUtils().logInfo('${bloc.runtimeType} $change');
    }
  }

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

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    if (logErrors) {
      LoggerUtils().logError('${bloc.runtimeType} $error');
    }
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    if (logClosed) {
      LoggerUtils().logInfo('${bloc.runtimeType} closed');
    }
  }

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    if (logCreated) {
      LoggerUtils().logInfo('${bloc.runtimeType} created');
    }
  }
}
