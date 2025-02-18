import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/app/l10n/app_l10n.g.dart';
import 'package:flutter_supabase_auth/app/widgets/alert_dialog/custom_alert_dialog.dart';
import 'package:flutter_supabase_auth/core/enums/snackbar_state.dart';
import 'package:flutter_supabase_auth/core/utils/snackbar/snackbar_utils.dart';
import 'package:go_router/go_router.dart';

class CustomErrorWidget {
  /// Shows either a [SnackbarUtils.showSnackbar] if [failure] is [AuthFailure],
  /// or a [CustomAlertDialog] for all other failure types.
  ///
  /// Example:
  /// ```dart
  /// CustomErrorWidget.show(
  ///   context,
  ///   failure: NoInternetFailure(),
  ///   onPressed: () {
  ///     // Retry logic...
  ///   },
  /// );
  /// ```
  static Future<T?> show<T>(
    BuildContext context, {
    required Failure failure,
    VoidCallback? onPressed,
    bool barrierDismissible = true,
  }) {
    // 1) Special handling for AuthFailure
    if (failure is AuthFailure) {
      SnackbarUtils.showSnackbar(
        context: context,
        message: failure.message
            .tr(), // or simply failure.message if already localized
        state: SnackbarState.error, // Adjust to your enum or style
      );
      // Return a resolved Future since we're not showing a dialog
      return Future.value();
    }

    // 2) Otherwise, handle all other failures with your existing CustomAlertDialog
    final errorMessage = switch (failure) {
      UnknownFailure() => LocaleKeys.errors_messages_unknown_error.tr(),
      NullResponseFailure() =>
        LocaleKeys.errors_messages_null_response_error.tr(),
      DatabaseFailure() => LocaleKeys.errors_messages_database_error.tr(),
      NoInternetFailure() => LocaleKeys.errors_messages_no_internet_error.tr(),
      _ => LocaleKeys.errors_messages_unknown_error.tr(),
    };

    final (String dialogTitle, Widget dialogIcon) = switch (failure) {
      NoInternetFailure() => (
          LocaleKeys.errors_titles_no_internet.tr(),
          Icon(Icons.wifi_off, color: Colors.red, size: 48.sp)
        ),
      DatabaseFailure() => (
          LocaleKeys.errors_titles_database_error.tr(),
          Icon(Icons.storage_rounded, color: Colors.orange, size: 48.sp)
        ),
      NullResponseFailure() => (
          LocaleKeys.errors_titles_empty_response.tr(),
          Icon(Icons.cloud_off, color: Colors.blueGrey, size: 48.sp)
        ),
      UnknownFailure() => (
          LocaleKeys.errors_titles_unknown_error.tr(),
          Icon(Icons.error_outline, color: Colors.redAccent, size: 48.sp)
        ),
      _ => (
          LocaleKeys.errors_titles_unknown_error.tr(),
          Icon(Icons.error_outline, color: Colors.redAccent, size: 48.sp)
        ),
    };

    final primaryButtonText = LocaleKeys.common_retry.tr();

    return CustomAlertDialog.show<T>(
      context,
      barrierDismissible: barrierDismissible,
      icon: dialogIcon,
      title: dialogTitle,
      message: errorMessage,
      primaryButtonText: primaryButtonText,
      blurBackground: true,
      actionsAlignment: MainAxisAlignment.center,
      onPrimaryButtonTap: onPressed ?? () => context.pop(),
    );
  }
}
