import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/widgets/auth_form.dart';

mixin AuthFormMixin on State<AuthForm> {
  final formKey = GlobalKey<FormState>();
  // TODO : Remove the default values
  final emailController = TextEditingController(text: 'deneme@gmail.com');
  final passwordController = TextEditingController(text: '123123Aa!');
  final fullNameController = TextEditingController(text: 'Deneme Deneme');
  final usernameController = TextEditingController(text: 'deneme');
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void onAuthTap() {
    if (formKey.currentState?.validate() ?? false) {
      if (widget.isSignUp) {
        context.read<AuthBloc>().add(
          SignUpEvent(
            email: emailController.text,
            password: passwordController.text,
            fullName: fullNameController.text,
            username: usernameController.text,
          ),
        );
      } else {
        context.read<AuthBloc>().add(
          SignInEvent(
            email: emailController.text,
            password: passwordController.text,
          ),
        );
      }
    }
  }
}
