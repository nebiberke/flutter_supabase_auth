import 'package:flutter/material.dart';
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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: AuthForm(
            isSignUp: _isSignUp,
            onToggleAuth: _toggleAuth,
          ),
        ),
      ),
    );
  }
}
