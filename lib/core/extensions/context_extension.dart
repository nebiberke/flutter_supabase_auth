import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension ScreenUtilExtension on BuildContext {
  ScreenUtil get screenUtil => ScreenUtil();

  /// Returns true if the device's screen is small
  bool get isMinecraft => !(ScreenUtil().pixelRatio! >= 2.90);

  /// Returns the height of the device
  double get height => ScreenUtil().screenHeight;

  /// Returns the width of the device
  double get width => ScreenUtil().screenWidth;

  /// Returns the status bar height
  double get statusBarHeight => ScreenUtil().statusBarHeight;

  /// Returns the bottom bar height
  double get bottomBarHeight => ScreenUtil().bottomBarHeight;

  /// Vertical Spacing
  SizedBox get verticalSpacingVeryLow2x => ScreenUtil().setVerticalSpacing(4);
  SizedBox get verticalSpacingVeryLow => ScreenUtil().setVerticalSpacing(8);
  SizedBox get verticalSpacingLow => ScreenUtil().setVerticalSpacing(12);
  SizedBox get verticalSpacingMedium => ScreenUtil().setVerticalSpacing(16);
  SizedBox get verticalSpacingHigh => ScreenUtil().setVerticalSpacing(24);
  SizedBox get verticalSpacingVeryHigh => ScreenUtil().setVerticalSpacing(32);
  SizedBox get verticalSpacingVeryHigh2x => ScreenUtil().setVerticalSpacing(40);
  SizedBox get verticalSpacingVeryHigh3x => ScreenUtil().setVerticalSpacing(48);

  /// Horizontal Spacing
  SizedBox get horizontalSpacingVeryLow2x =>
      ScreenUtil().setHorizontalSpacing(4);
  SizedBox get horizontalSpacingVeryLow => ScreenUtil().setHorizontalSpacing(8);
  SizedBox get horizontalSpacingLow => ScreenUtil().setHorizontalSpacing(12);
  SizedBox get horizontalSpacingMedium => ScreenUtil().setHorizontalSpacing(16);
  SizedBox get horizontalSpacingHigh => ScreenUtil().setHorizontalSpacing(24);
  SizedBox get horizontalSpacingVeryHigh =>
      ScreenUtil().setHorizontalSpacing(32);
  SizedBox get horizontalSpacingVeryHigh2x =>
      ScreenUtil().setHorizontalSpacing(40);
  SizedBox get horizontalSpacingVeryHigh3x =>
      ScreenUtil().setHorizontalSpacing(48);

  double dynamicHeight(double val) => ScreenUtil().setHeight(val);
  double dynamicWidth(double val) => ScreenUtil().setWidth(val);
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
