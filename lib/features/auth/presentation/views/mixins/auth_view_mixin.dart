import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/app/widgets/error/custom_error_widget.dart';
import 'package:flutter_supabase_auth/core/enums/auth_status.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/views/auth_view.dart';

mixin AuthViewMixin on State<AuthView> {
  final ValueNotifier<bool> isSignUpNotifier = ValueNotifier(false);

  void toggleAuth() {
    isSignUpNotifier.value = !isSignUpNotifier.value;
  }

  @override
  void dispose() {
    isSignUpNotifier.dispose();
    super.dispose();
  }

  void onAuthError(BuildContext context, AuthState state) {
    if (state.status == AuthStatus.error) {
      CustomErrorWidget.show<void>(context, failure: state.failure!);
    }
  }
}
