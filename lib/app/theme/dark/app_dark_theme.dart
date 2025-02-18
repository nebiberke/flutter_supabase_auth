import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/app/theme/base/base_app_theme.dart';
import 'package:flutter_supabase_auth/app/theme/color_scheme/app_color_scheme.dart';

final class AppDarkTheme extends BaseAppTheme {
  @override
  Brightness get brightness => Brightness.dark;

  @override
  ColorScheme get colorScheme => AppColorScheme.darkColorScheme;
}
