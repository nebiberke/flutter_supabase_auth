import 'dart:ui'; // Required for ImageFilter.blur

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_supabase_auth/app/constants/duration_constants.dart';
import 'package:flutter_supabase_auth/app/constants/theme_constants.dart';
import 'package:flutter_supabase_auth/core/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';

/// A reusable and customizable AlertDialog component
/// that can blur the background behind it, if desired.
///
/// You can use this component for various scenarios such as:
/// - Error dialogs (e.g., "No Internet Connection")
/// - Success messages
/// - Warnings or confirmations with one or two buttons
///
/// Example usage:
/// ```dart
/// CustomAlertDialog.show(
///   context,
///   icon: Icon(Icons.warning, size: 48, color: Colors.orange),
///   title: "Warning",
///   message: "This action cannot be undone. Do you wish to proceed?",
///   primaryButtonText: "Yes",
///   onPrimaryButtonTap: () {
///     // Action for "Yes"
///   },
///   secondaryButtonText: "No",
///   onSecondaryButtonTap: () {
///     // Action for "No"
///   },
///   blurBackground: true, // Enable background blur
///   blurSigmaX: 5,
///   blurSigmaY: 5,
/// );
/// ```
class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    required this.title,
    required this.primaryButtonText,
    super.key,
    this.icon,
    this.message,
    this.onPrimaryButtonTap,
    this.secondaryButtonText,
    this.onSecondaryButtonTap,
    this.actionsAlignment,
  });

  /// Optional icon displayed at the top of the dialog.
  final Widget? icon;

  /// Dialog title (required).
  final String title;

  /// Optional message or description of the dialog.
  final String? message;

  /// Text for the primary button (required).
  final String primaryButtonText;

  /// Callback triggered when the primary button is tapped (optional).
  /// Defaults to closing the dialog if not provided.
  final VoidCallback? onPrimaryButtonTap;

  /// Text for the optional secondary button.
  final String? secondaryButtonText;

  /// Callback triggered when the secondary button is tapped (optional).
  /// Defaults to closing the dialog if not provided.
  final VoidCallback? onSecondaryButtonTap;

  /// Alignment of the actions in the dialog.
  final MainAxisAlignment? actionsAlignment;

  /// Displays this [CustomAlertDialog] with an optional blurred background.
  ///
  /// - [blurBackground] determines whether the background behind the dialog is blurred.
  /// - [blurSigmaX] and [blurSigmaY] define the strength of the blur effect on the X and Y axes.
  /// - [barrierColor] sets the color overlay behind the dialog. Often a semi-transparent color is used.
  /// - [barrierDismissible] specifies whether tapping outside the dialog dismisses it. Defaults to `true`.
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String primaryButtonText,
    Key? key,
    Widget? icon,
    String? message,
    VoidCallback? onPrimaryButtonTap,
    String? secondaryButtonText,
    VoidCallback? onSecondaryButtonTap,
    bool barrierDismissible = true,
    bool blurBackground = false,
    double blurSigmaX = 5.0,
    double blurSigmaY = 5.0,
    Color barrierColor = Colors.black54,
    MainAxisAlignment? actionsAlignment,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierDismissible: barrierDismissible,
      // We use transparent here so we can manage the background color/blur ourselves.
      barrierColor: Colors.transparent,
      transitionDuration: DurationConstants.ms120(),
      pageBuilder: (ctx, animation, secondaryAnimation) {
        return GestureDetector(
          // If [barrierDismissible] is true, tapping outside closes the dialog.
          onTap: barrierDismissible ? () => ctx.pop() : null,
          child: SizedBox.expand(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Conditionally apply a blur filter to the background.
                if (blurBackground)
                  BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: blurSigmaX,
                      sigmaY: blurSigmaY,
                    ),
                    child: Container(color: barrierColor),
                  )
                else
                  Container(color: barrierColor),
                // The actual dialog. We use another GestureDetector to prevent
                // tapping on the dialog from closing it unintentionally.
                GestureDetector(
                  onTap: () {},
                  child: CustomAlertDialog(
                    key: key,
                    icon: icon,
                    title: title,
                    message: message,
                    primaryButtonText: primaryButtonText,
                    onPrimaryButtonTap: onPrimaryButtonTap,
                    secondaryButtonText: secondaryButtonText,
                    onSecondaryButtonTap: onSecondaryButtonTap,
                    actionsAlignment: actionsAlignment,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (ctx, anim, secondaryAnim, child) {
        // Fade-in transition for the dialog.
        return FadeTransition(
          opacity: anim,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: ThemeConstants.borderRadiusCircular12,
      ),
      contentPadding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
      actionsAlignment: actionsAlignment,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            context.verticalSpacingLow,
          ],
          Text(
            title,
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (message != null) ...[
            context.verticalSpacingLow,
            Text(
              message!,
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
      actions: _buildDialogActions(context),
    );
  }

  /// Builds one or two action buttons, depending on whether
  /// [secondaryButtonText] is provided.
  List<Widget> _buildDialogActions(BuildContext context) {
    final primaryButton = TextButton(
      onPressed: onPrimaryButtonTap ?? () => context.pop(),
      child: Text(
        primaryButtonText,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );

    if (secondaryButtonText != null) {
      final secondaryButton = TextButton(
        onPressed: onSecondaryButtonTap ?? () => context.pop(),
        child: Text(secondaryButtonText!),
      );
      return [secondaryButton, primaryButton];
    } else {
      return [primaryButton];
    }
  }
}
