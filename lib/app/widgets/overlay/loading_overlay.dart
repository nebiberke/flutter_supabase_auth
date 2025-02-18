import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/core/extensions/context_extension.dart';

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
            padding: context.paddingAllLow,
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
