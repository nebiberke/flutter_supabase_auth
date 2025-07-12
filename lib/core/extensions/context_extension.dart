import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension ScreenUtilExtension on BuildContext {
  ScreenUtil get screenUtil => ScreenUtil();

  /// Returns true if the device's screen is small
  bool get isMinecraft => !(screenUtil.pixelRatio! >= 2.90);

  /// Returns the height of the device
  double get height => screenUtil.screenHeight;

  /// Returns the width of the device
  double get width => screenUtil.screenWidth;

  /// Returns the status bar height
  double get statusBarHeight => screenUtil.statusBarHeight;

  /// Returns the bottom bar height
  double get bottomBarHeight => screenUtil.bottomBarHeight;

  /// Vertical Spacing
  SizedBox get verticalSpacingVeryLow2x => 4.verticalSpace;
  SizedBox get verticalSpacingVeryLow => 8.verticalSpace;
  SizedBox get verticalSpacingLow => 12.verticalSpace;
  SizedBox get verticalSpacingMedium => 16.verticalSpace;
  SizedBox get verticalSpacingHigh => 24.verticalSpace;
  SizedBox get verticalSpacingVeryHigh => 32.verticalSpace;
  SizedBox get verticalSpacingVeryHigh2x => 40.verticalSpace;
  SizedBox get verticalSpacingVeryHigh3x => 48.verticalSpace;

  /// Horizontal Spacing
  SizedBox get horizontalSpacingVeryLow2x => 4.horizontalSpace;
  SizedBox get horizontalSpacingVeryLow => 8.horizontalSpace;
  SizedBox get horizontalSpacingLow => 12.horizontalSpace;
  SizedBox get horizontalSpacingMedium => 16.horizontalSpace;
  SizedBox get horizontalSpacingHigh => 24.horizontalSpace;
  SizedBox get horizontalSpacingVeryHigh => 32.horizontalSpace;
  SizedBox get horizontalSpacingVeryHigh2x => 40.horizontalSpace;
  SizedBox get horizontalSpacingVeryHigh3x => 48.horizontalSpace;

  double dynamicHeight(double val) => screenUtil.setHeight(val);
  double dynamicWidth(double val) => screenUtil.setWidth(val);
}

extension ThemeExtension on BuildContext {
  /// Get the theme data
  ThemeData get theme => Theme.of(this);

  /// Get the color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Get the text theme
  TextTheme get textTheme => Theme.of(this).textTheme;
}

extension MediaExtension on BuildContext {
  /// Get the media query data
  MediaQueryData get mediaQuery => MediaQuery.of(this);
}
