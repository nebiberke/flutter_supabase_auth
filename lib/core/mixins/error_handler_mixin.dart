import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/app/widgets/error/custom_error_widget.dart';
import 'package:flutter_supabase_auth/core/enums/auth_status.dart';
import 'package:flutter_supabase_auth/core/enums/bloc_status.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/profile/profile_state.dart';

/// Base mixin for common error handling across the app
mixin ErrorHandlerMixin {
  /// Handle the [AuthState] error
  void onAuthError(BuildContext context, AuthState state) {
    CustomErrorWidget.show<void>(context, failure: state.failure!);
  }

  /// Listen when the [AuthState] is error
  bool onAuthListenWhen(AuthState previous, AuthState current) {
    return previous.status != current.status &&
        current.status == AuthStatus.error;
  }

  /// Handle the [ProfileState] error
  void onProfileError(BuildContext context, ProfileState state) {
    CustomErrorWidget.show<void>(context, failure: state.failure!);
  }

  /// Listen when the [ProfileState] is error
  bool onProfileListenWhen(ProfileState previous, ProfileState current) {
    return previous.status != current.status &&
        current.status == BlocStatus.error;
  }
}
