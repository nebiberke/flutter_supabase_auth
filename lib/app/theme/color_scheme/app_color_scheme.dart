import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/app/constants/color_constants.dart';

// Project custom color scheme
final class AppColorScheme {
  AppColorScheme._();

  // Light Theme Colors
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF007AFF),
    onPrimary: Color(0xFFFFFFFF),
    onPrimaryContainer: Color(0xFFFFFFFF),
    secondary: Color(0xFFFFA726),
    onSecondary: Color(0xFF333333),
    secondaryContainer: Color(0xFFFFD54F),
    tertiary: Color(0xFF4CAF50),
    outline: Color(0xFFE0E0E0),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF212121),
    error: ColorConstants.error,
    onError: Color(0xFFFFFFFF),
  );

  // Dark Theme Colors
  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF0A84FF),
    onPrimary: Color(0xFF1E1E1E),
    onPrimaryContainer: Color(0xFFFFFFFF),
    secondary: Color(0xFFFFA726),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFFFC107),
    tertiary: Color(0xFF81C784),
    outline: Color(0xFF424242),
    surface: Color(0xFF121212),
    onSurface: Color(0xFFF5F5F5),
    error: ColorConstants.error,
    onError: Color(0xFF000000),
  );
}
