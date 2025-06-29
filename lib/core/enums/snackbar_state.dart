import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/app/constants/status_color_constants.dart';

/// An enum representing the state of a snackbar.
///
enum SnackbarState {
  /// The color for success messages.
  success(color: StatusColorConstants.successColor),

  /// The color for error messages.
  error(color: StatusColorConstants.errorColor),

  /// The color for warning messages.
  warning(color: StatusColorConstants.warningColor),

  /// The color for info messages.
  info(color: StatusColorConstants.infoColor);

  const SnackbarState({required this.color});
  final Color color;
}
