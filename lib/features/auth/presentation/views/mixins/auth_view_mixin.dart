import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/views/auth_view.dart';

mixin AuthViewMixin on State<AuthView> {
  /// Notifier for the auth view
  final ValueNotifier<bool> isSignUpNotifier = ValueNotifier(false);

  /// Toggle the auth view
  void toggleAuth() {
    isSignUpNotifier.value = !isSignUpNotifier.value;
  }

  /// Dispose for the auth view
  @override
  void dispose() {
    isSignUpNotifier.dispose();
    super.dispose();
  }
}
