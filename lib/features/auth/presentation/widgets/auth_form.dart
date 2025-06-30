import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_auth/app/constants/padding_constants.dart';
import 'package:flutter_supabase_auth/app/l10n/app_l10n.g.dart';
import 'package:flutter_supabase_auth/app/widgets/button/custom_elevated_button.dart';
import 'package:flutter_supabase_auth/app/widgets/button/custom_outlined_button.dart';
import 'package:flutter_supabase_auth/app/widgets/text_field/custom_text_field.dart';
import 'package:flutter_supabase_auth/core/enums/auth_status.dart';
import 'package:flutter_supabase_auth/core/extensions/context_extension.dart';
import 'package:flutter_supabase_auth/core/utils/custom_validator.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/bloc/auth_state.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    required this.isSignUp,
    required this.onToggleAuth,
    super.key,
  });
  final bool isSignUp;
  final VoidCallback onToggleAuth;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  // TODO : Remove the default values
  final _emailController = TextEditingController(text: 'deneme@gmail.com');
  final _passwordController = TextEditingController(text: '123123Aa!');
  final _fullNameController = TextEditingController(text: 'Deneme Deneme');
  final _usernameController = TextEditingController(text: 'deneme');
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _onAuthTap() {
    if (_formKey.currentState?.validate() ?? false) {
      if (widget.isSignUp) {
        context.read<AuthBloc>().add(
          SignUpEvent(
            email: _emailController.text,
            password: _passwordController.text,
            fullName: _fullNameController.text,
            username: _usernameController.text,
          ),
        );
      } else {
        context.read<AuthBloc>().add(
          SignInEvent(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: PaddingConstants.allHigh(),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.isSignUp
                  ? LocaleKeys.auth_actions_sign_up.tr()
                  : LocaleKeys.auth_actions_sign_in.tr(),
              style: context.textTheme.headlineMedium,
            ),
            context.verticalSpacingHigh,
            if (widget.isSignUp) ...[
              CustomTextField(
                label: LocaleKeys.auth_fields_full_name.tr(),
                controller: _fullNameController,
                validator: CustomValidator.fullNameValidator,
              ),
              CustomTextField(
                label: LocaleKeys.auth_fields_username.tr(),
                controller: _usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocaleKeys.auth_validation_email_required.tr();
                  }
                  return null;
                },
              ),
            ],
            CustomTextField(
              label: LocaleKeys.auth_fields_email.tr(),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: CustomValidator.emailValidator,
            ),
            CustomTextField(
              label: LocaleKeys.auth_fields_password.tr(),
              controller: _passwordController,
              obscureText: true,
              validator: CustomValidator.passwordValidator,
            ),
            context.verticalSpacingHigh,
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return CustomElevatedButton(
                  text: widget.isSignUp
                      ? LocaleKeys.auth_actions_sign_up.tr()
                      : LocaleKeys.auth_actions_sign_in.tr(),
                  onPressed: _onAuthTap,
                  showingLoadingIndicator: state.status == AuthStatus.loading,
                );
              },
            ),
            context.verticalSpacingLow,
            CustomOutlinedButton(
              text: widget.isSignUp
                  ? LocaleKeys.auth_actions_sign_in.tr()
                  : LocaleKeys.auth_actions_sign_up.tr(),
              onPressed: widget.onToggleAuth,
            ),
          ],
        ),
      ),
    );
  }
}
