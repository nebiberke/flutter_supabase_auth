import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/app/constants/status_color_constants.dart';

/// Project custom color scheme
final class AppColorScheme {
  AppColorScheme._();

  /// Light Theme Colors
  static const lightColorScheme = ColorScheme.light(
    primary: Color(0xFF007AFF),
    onPrimaryContainer: Color(0xFFFFFFFF),
    secondary: Color(0xFFFFA726),
    onSecondary: Color(0xFF333333),
    secondaryContainer: Color(0xFFFFD54F),
    tertiary: Color(0xFF4CAF50),
    outline: Color(0xFFE0E0E0),
    onSurface: Color(0xFF212121),
    error: StatusColorConstants.errorColor,
  );

  /// Dark Theme Colors
  static const darkColorScheme = ColorScheme.dark(
    primary: Color(0xFF0A84FF),
    onPrimary: Color(0xFF1E1E1E),
    onPrimaryContainer: Color(0xFFFFFFFF),
    secondary: Color(0xFFFFA726),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFFFC107),
    tertiary: Color(0xFF81C784),
    outline: Color(0xFF424242),
    onSurface: Color(0xFFF5F5F5),
    error: StatusColorConstants.errorColor,
  );
}
