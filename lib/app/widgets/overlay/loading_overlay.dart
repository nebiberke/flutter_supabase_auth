import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/app/constants/padding_constants.dart';
import 'package:flutter_supabase_auth/core/extensions/context_extension.dart';

/// A widget that displays a loading overlay with a blur effect.
///
/// This widget is used to display a loading overlay when a task is in progress.
/// It is a circular progress indicator with a blur effect.
///
/// Example usage:
/// ```dart
/// LoadingOverlay.show(context);
/// ```
final class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: ColoredBox(
        color: Colors.black.withAlpha(50),
        child: Center(
          child: Container(
            padding: PaddingConstants.allLow,
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
