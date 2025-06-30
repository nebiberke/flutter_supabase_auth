import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/core/extensions/context_extension.dart';

final class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
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
