import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_supabase_auth/app/constants/theme_constants.dart';

abstract base class BaseAppTheme {
  Brightness get brightness;

  ColorScheme get colorScheme;

  ThemeData get themeData => ThemeData(
        fontFamily: 'Roboto',
        brightness: brightness,
        colorScheme: colorScheme,
        typography: Typography.material2021(),
        textTheme: _textTheme,
        elevatedButtonTheme: _elevatedButtonTheme,
        outlinedButtonTheme: _outlinedButtonTheme,
        inputDecorationTheme: _inputDecorationTheme,
      );

  final OutlinedButtonThemeData _outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: ThemeConstants.noElevation,
      minimumSize: const Size.fromHeight(kToolbarHeight),
      shape: RoundedRectangleBorder(
        borderRadius: ThemeConstants.borderRadiusCircular12,
      ),
    ),
  );

  final ElevatedButtonThemeData _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: ThemeConstants.noElevation,
      shadowColor: Colors.transparent,
      minimumSize: const Size.fromHeight(kToolbarHeight),
      shape: RoundedRectangleBorder(
        borderRadius: ThemeConstants.borderRadiusCircular12,
      ),
    ),
  );

  final InputDecorationTheme _inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: ThemeConstants.borderRadiusCircular12,
    ),
  );

  final TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 48.sp,
      fontWeight: FontWeight.bold,
      letterSpacing: -1.2,
    ),
    displayMedium: TextStyle(
      fontSize: 40.sp,
      fontWeight: FontWeight.bold,
      letterSpacing: -1,
    ),
    displaySmall: TextStyle(
      fontSize: 34.sp,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.8,
    ),
    headlineLarge: TextStyle(
      fontSize: 28.sp,
      fontWeight: FontWeight.w700,
    ),
    headlineMedium: TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w500,
    ),
    titleLarge: TextStyle(
      fontSize: 22.sp,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      height: 1.4,
    ),
    bodySmall: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      height: 1.3,
    ),
    labelLarge: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.8,
    ),
    labelMedium: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.6,
    ),
    labelSmall: TextStyle(
      fontSize: 10.sp,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    ),
  );
}
