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

  /// Returns 2% of the screen height
  double get lowValue => height * 0.02;

  /// Default value is 3,5% of the screen height
  double get defaultValue => height * 0.035;

  /// Returns 5% of the screen height
  double get highValue => height * 0.05;

  /// Returns 10% of the screen height
  double get veryhighValue1x => height * 0.1;

  /// Returns 20% of the screen height
  double get veryhighValue2x => height * 0.2;

  /// Returns 30% of the screen height
  double get veryhighValue3x => height * 0.3;

  /// Returns 40% of the screen height
  double get veryhighValue4x => height * 0.4;

  /// Returns 50% of the screen height
  double get veryhighValue5x => height * 0.5;

  /// Returns vertical spacing of 1% of the screen height
  SizedBox get verticalSpacingLow => ScreenUtil().setVerticalSpacing(lowValue);

  /// Returns vertical spacing of 2% of the screen height
  SizedBox get verticalSpacingDefault =>
      ScreenUtil().setVerticalSpacing(defaultValue);

  /// Returns vertical spacing of 5% of the screen height
  SizedBox get verticalSpacingHigh =>
      ScreenUtil().setVerticalSpacing(highValue);

  /// Returns vertical spacing of 10% of the screen height
  SizedBox get horizontalSpacingLow =>
      ScreenUtil().setHorizontalSpacing(lowValue);

  /// Returns horizontal spacing of 2% of the screen height
  SizedBox get horizontalSpacingDefault =>
      ScreenUtil().setHorizontalSpacing(defaultValue);

  /// Returns horizontal spacing of 5% of the screen height
  SizedBox get horizontalSpacingHigh =>
      ScreenUtil().setHorizontalSpacing(highValue);

  double dynamicHeight(double val) => ScreenUtil().setHeight(val);
  double dynamicWidth(double val) => ScreenUtil().setWidth(val);
}

extension PaddingExtension on BuildContext {
  /// Adds 1% padding from all sides.
  EdgeInsets get paddingAllLow => EdgeInsets.all(lowValue);

  /// Adds 2% padding from all sides.
  /// Use this when you want to add padding from all sides.
  EdgeInsets get paddingAllDefault => EdgeInsets.all(defaultValue);

  /// Adds 5% padding from all sides.
  EdgeInsets get paddingAllHigh => EdgeInsets.all(highValue);

  /// Adds 1% padding horizontally.
  EdgeInsets get paddingHorizontalLow =>
      EdgeInsets.symmetric(horizontal: lowValue);

  /// Adds 2% padding horizontally.
  /// Use this when you want to add padding horizontally.
  EdgeInsets get paddingHorizontalDefault =>
      EdgeInsets.symmetric(horizontal: defaultValue);

  /// Adds 5% padding horizontally.
  EdgeInsets get paddingHorizontalHigh =>
      EdgeInsets.symmetric(horizontal: highValue);

  /// Adds 1% padding vertically.
  EdgeInsets get paddingVerticalLow => EdgeInsets.symmetric(vertical: lowValue);

  /// Adds 2% padding vertically.
  /// Use this when you want to add padding vertically.
  EdgeInsets get paddingVerticalDefault =>
      EdgeInsets.symmetric(vertical: defaultValue);

  /// Adds 5% padding vertically.
  EdgeInsets get paddingVerticalHigh =>
      EdgeInsets.symmetric(vertical: highValue);

  /// Adds 1% padding from right.
  EdgeInsets get paddingRightLow => EdgeInsets.only(right: lowValue);

  /// Adds 2% padding from right.
  /// Use this when you want to add padding from right.
  EdgeInsets get paddingRightDefault => EdgeInsets.only(right: defaultValue);

  /// Adds 5% padding from right.
  EdgeInsets get paddingRightHigh => EdgeInsets.only(right: highValue);

  /// Adds 1% padding from left.
  EdgeInsets get paddingLeftLow => EdgeInsets.only(left: lowValue);

  /// Adds 2% padding from left.
  /// Use this when you want to add padding from left.
  EdgeInsets get paddingLeftDefault => EdgeInsets.only(left: defaultValue);

  /// Adds 5% padding from left.
  EdgeInsets get paddingLeftHigh => EdgeInsets.only(left: highValue);

  /// Adds 1% padding from top.
  EdgeInsets get paddingTopLow => EdgeInsets.only(top: lowValue);

  /// Adds 2% padding from top.
  /// Use this when you want to add padding from top.
  EdgeInsets get paddingTopDefault => EdgeInsets.only(top: defaultValue);

  /// Adds 5% padding from top.
  EdgeInsets get paddingTopHigh => EdgeInsets.only(top: highValue);

  /// Adds 1% padding from bottom.
  EdgeInsets get paddingBottomLow => EdgeInsets.only(bottom: lowValue);

  /// Adds 2% padding from bottom.
  /// Use this when you want to add padding from bottom.
  EdgeInsets get paddingBottomDefault => EdgeInsets.only(bottom: defaultValue);

  /// Adds 5% padding from bottom.
  EdgeInsets get paddingBottomHigh => EdgeInsets.only(bottom: highValue);
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
