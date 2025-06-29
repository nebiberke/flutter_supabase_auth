import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/core/enums/snackbar_state.dart';
import 'package:flutter_supabase_auth/core/extensions/context_extension.dart';

/// A utility class for showing snackbars with customizable styles.
///
/// Example usage:
/// ```dart
/// SnackbarUtils.showSnackbar(
///   context,
///   message: "This is a snackbar message",
///   state: SnackbarState.success,
///   backgroundColor: Colors.green,
/// );
/// ```
final class SnackbarUtils {
  /// Shows a snackbar with the given message, state, and background color.
  ///
  /// [context] is the context of the snackbar.
  /// [message] is the message to be displayed in the snackbar.
  /// [state] is the state of the snackbar.
  /// [backgroundColor] is the background color of the snackbar.
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
          backgroundColor: backgroundColor ?? state.color,
          content: Text(
            message,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          duration: Durations.extralong4,
          showCloseIcon: true,
        ),
      );
  }
}
