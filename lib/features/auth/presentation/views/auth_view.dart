import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_auth/core/mixins/error_handler_mixin.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/bloc/auth_state.dart'
    show AuthState;
import 'package:flutter_supabase_auth/features/auth/presentation/views/mixins/auth_view_mixin.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/widgets/auth_form.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView>
    with AuthViewMixin, ErrorHandlerMixin {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: onAuthListenWhen,
      listener: onAuthError,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ValueListenableBuilder(
              valueListenable: isSignUpNotifier,
              builder: (context, isSignUp, child) =>
                  AuthForm(isSignUp: isSignUp, onToggleAuth: toggleAuth),
            ),
          ),
        ),
      ),
    );
  }
}
