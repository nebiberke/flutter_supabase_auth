import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/app/constants/theme_constants.dart';
import 'package:flutter_supabase_auth/core/extensions/context_extension.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.textAlign,
    this.showingLoadingIndicator,
  });

  final bool? showingLoadingIndicator;
  final void Function()? onPressed;
  final String text;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: showingLoadingIndicator ?? false ? null : onPressed,
      child: showingLoadingIndicator ?? false
          ? const CircularProgressIndicator.adaptive()
          : Text(
              text,
              textAlign: textAlign,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.primary,
                fontWeight: ThemeConstants.fontWeightBold,
              ),
            ),
    );
  }
}
