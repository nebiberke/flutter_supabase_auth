import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/app/constants/duration_constants.dart';
import 'package:flutter_supabase_auth/app/constants/theme_constants.dart';
import 'package:flutter_supabase_auth/core/enums/snackbar_state.dart';
import 'package:flutter_supabase_auth/core/extensions/context_extension.dart';

final class SnackbarUtils {
  static void showSnackbar({
    required BuildContext context,
    required String message,
    required SnackbarState state,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          padding: context.paddingAllDefault,
          backgroundColor: backgroundColor ?? state.color,
          content: Text(
            message,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.theme.colorScheme.onPrimary,
              fontWeight: ThemeConstants.fontWeightSemiBold,
            ),
          ),
          duration: DurationConstants.s4(),
          showCloseIcon: true,
        ),
      );
  }
}
