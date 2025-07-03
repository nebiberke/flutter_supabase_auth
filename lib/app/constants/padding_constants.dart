import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized padding values using [ScreenUtil] for responsive design.
/// Example usage:
/// ```dart
/// padding: PaddingConstants.allHigh,
/// ```
abstract final class PaddingConstants {
  /// All Padding
  /// allVeryLow2x => 4.w
  static EdgeInsets get allVeryLow2x => EdgeInsets.all(4.w);

  /// allVeryLow => 8.w
  static EdgeInsets get allVeryLow => EdgeInsets.all(8.w);

  /// allLow => 12.w
  static EdgeInsets get allLow => EdgeInsets.all(12.w);

  /// allMedium => 16.w
  static EdgeInsets get allMedium => EdgeInsets.all(16.w);

  /// allHigh => 24.w
  static EdgeInsets get allHigh => EdgeInsets.all(24.w);

  /// allVeryHigh => 32.w
  static EdgeInsets get allVeryHigh => EdgeInsets.all(32.w);

  /// allVeryHigh2x => 40.w
  static EdgeInsets get allVeryHigh2x => EdgeInsets.all(40.w);

  /// allVeryHigh3x => 48.w
  static EdgeInsets get allVeryHigh3x => EdgeInsets.all(48.w);

  /// Vertical Padding
  /// verticalVeryLow2x => 4.h
  static EdgeInsets get verticalVeryLow2x =>
      EdgeInsets.symmetric(vertical: 4.h);

  /// verticalVeryLow => 8.h
  static EdgeInsets get verticalVeryLow => EdgeInsets.symmetric(vertical: 8.h);

  /// verticalLow => 12.h
  static EdgeInsets get verticalLow => EdgeInsets.symmetric(vertical: 12.h);

  /// verticalMedium => 16.h
  static EdgeInsets get verticalMedium => EdgeInsets.symmetric(vertical: 16.h);

  /// verticalHigh => 24.h
  static EdgeInsets get verticalHigh => EdgeInsets.symmetric(vertical: 24.h);

  /// verticalVeryHigh => 32.h
  static EdgeInsets get verticalVeryHigh =>
      EdgeInsets.symmetric(vertical: 32.h);

  /// verticalVeryHigh2x => 40.h
  static EdgeInsets get verticalVeryHigh2x =>
      EdgeInsets.symmetric(vertical: 40.h);

  /// verticalVeryHigh3x => 48.h
  static EdgeInsets get verticalVeryHigh3x =>
      EdgeInsets.symmetric(vertical: 48.h);

  /// Horizontal Padding
  /// horizontalVeryLow2x => 4.w
  static EdgeInsets get horizontalVeryLow2x =>
      EdgeInsets.symmetric(horizontal: 4.w);

  /// horizontalVeryLow => 8.w
  static EdgeInsets get horizontalVeryLow =>
      EdgeInsets.symmetric(horizontal: 8.w);

  /// horizontalLow => 12.w
  static EdgeInsets get horizontalLow => EdgeInsets.symmetric(horizontal: 12.w);

  /// horizontalMedium => 16.w
  static EdgeInsets get horizontalMedium =>
      EdgeInsets.symmetric(horizontal: 16.w);

  /// horizontalHigh => 24.w
  static EdgeInsets get horizontalHigh =>
      EdgeInsets.symmetric(horizontal: 24.w);

  /// horizontalVeryHigh => 32.w
  static EdgeInsets get horizontalVeryHigh =>
      EdgeInsets.symmetric(horizontal: 32.w);

  /// horizontalVeryHigh2x => 40.w
  static EdgeInsets get horizontalVeryHigh2x =>
      EdgeInsets.symmetric(horizontal: 40.w);

  /// horizontalVeryHigh3x => 48.w
  static EdgeInsets get horizontalVeryHigh3x =>
      EdgeInsets.symmetric(horizontal: 48.w);
}
