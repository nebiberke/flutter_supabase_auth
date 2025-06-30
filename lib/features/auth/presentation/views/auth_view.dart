import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_auth/app/widgets/error/custom_error_widget.dart';
import 'package:flutter_supabase_auth/core/enums/auth_status.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/bloc/auth_state.dart'
    show AuthState;
import 'package:flutter_supabase_auth/features/auth/presentation/widgets/auth_form.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool _isSignUp = false;

  void _toggleAuth() {
    setState(() {
      _isSignUp = !_isSignUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.error) {
          CustomErrorWidget.show<void>(context, failure: state.failure!);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: AuthForm(isSignUp: _isSignUp, onToggleAuth: _toggleAuth),
          ),
        ),
      ),
    );
  }
}
