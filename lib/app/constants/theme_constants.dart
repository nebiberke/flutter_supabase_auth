import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A utility class that provides common border radius values.
class ThemeConstants {
  ThemeConstants._();

  static const double noElevation = 0;

  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightSemiBold = FontWeight.w500;
  static const FontWeight fontWeightBold = FontWeight.w600;

  /// [BorderRadius] value 0
  static BorderRadius noBorderRadius = BorderRadius.zero;

  /// [BorderRadius] value 8
  static BorderRadius borderRadiusCircular =
      BorderRadius.all(Radius.circular(8.r));

  /// [BorderRadius] value 12
  static BorderRadius borderRadiusCircular12 =
      BorderRadius.all(Radius.circular(12.r));

  /// [BorderRadius] value 16
  static BorderRadius borderRadiusCircular16 =
      BorderRadius.all(Radius.circular(16.r));

  /// [BorderRadius] value 60
  static BorderRadius borderRadiusCircular60 =
      BorderRadius.all(Radius.circular(60.r));

  /// [Radius] value 60
  static const Radius mediumRadiusCircular = Radius.circular(60);
}
