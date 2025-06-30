import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A class that extends [BorderRadius] and provides constants for border radius values.
final class BorderRadiusConstants extends BorderRadius {
  const BorderRadiusConstants.all(super.radius) : super.all();

  /// [BorderRadius] value 0
  const BorderRadiusConstants.zero() : super.all(const RadiusConstants.zero());

  /// [BorderRadius] value 8
  BorderRadiusConstants.allLow() : super.all(RadiusConstants.low());

  /// [BorderRadius] value 12
  BorderRadiusConstants.allMedium() : super.all(RadiusConstants.medium());

  /// [BorderRadius] value 16
  BorderRadiusConstants.allHigh() : super.all(RadiusConstants.high());

  /// [BorderRadius] value 24
  BorderRadiusConstants.allExtraHigh() : super.all(RadiusConstants.extraHigh());

  /// [BorderRadius] value 120 for stadium shape
  BorderRadiusConstants.allExtraHigh5x()
    : super.all(RadiusConstants.extraHigh5x());
}

/// A class that extends [Radius] and provides constants for radius values.
final class RadiusConstants extends Radius {
  const RadiusConstants.circular(super.radius) : super.circular();

  /// [Radius] value 0
  const RadiusConstants.zero() : super.circular(0);

  /// [Radius] value 8
  RadiusConstants.low() : super.circular(8.r);

  /// [Radius] value 12
  RadiusConstants.medium() : super.circular(12.r);

  /// [Radius] value 16
  RadiusConstants.high() : super.circular(16.r);

  /// [Radius] value 24
  RadiusConstants.extraHigh() : super.circular(24.r);

  /// [Radius] value 48
  RadiusConstants.extraHigh2x() : super.circular(48.r);

  /// [Radius] value 72
  RadiusConstants.extraHigh3x() : super.circular(72.r);

  /// [Radius] value 96
  RadiusConstants.extraHigh4x() : super.circular(96.r);

  /// [Radius] value 120
  RadiusConstants.extraHigh5x() : super.circular(120.r);
}
