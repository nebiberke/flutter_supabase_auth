import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/core/extensions/context_extension.dart';

final class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.showingLoadingIndicator,
  });

  final bool? showingLoadingIndicator;
  final void Function()? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: context.colorScheme.primary,
        foregroundColor: context.colorScheme.onPrimary,
      ),
      onPressed: showingLoadingIndicator ?? false ? null : onPressed,
      child: showingLoadingIndicator ?? false
          ? const CircularProgressIndicator.adaptive()
          : Text(
              text,
              style: context.textTheme.labelLarge?.copyWith(
                color: context.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
