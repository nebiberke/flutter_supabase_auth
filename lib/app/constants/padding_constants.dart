import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized padding values using [ScreenUtil] for responsive design.
/// Example usage:
/// ```dart
/// padding: PaddingConstants.allHigh,
/// ```
abstract final class PaddingConstants {
  /// All Paddings
  /// allVeryLow2x => 4.w
  static const EdgeInsets allVeryLow2x = EdgeInsets.all(4);

  /// allVeryLow => 8.w
  static const EdgeInsets allVeryLow = EdgeInsets.all(8);

  /// allLow => 12.w
  static const EdgeInsets allLow = EdgeInsets.all(12);

  /// allMedium => 16.w
  static const EdgeInsets allMedium = EdgeInsets.all(16);

  /// allHigh => 24.w
  static const EdgeInsets allHigh = EdgeInsets.all(24);

  /// allVeryHigh => 32.w
  static const EdgeInsets allVeryHigh = EdgeInsets.all(32);

  /// allVeryHigh2x => 40.w
  static const EdgeInsets allVeryHigh2x = EdgeInsets.all(40);

  /// allVeryHigh3x => 48.w
  static const EdgeInsets allVeryHigh3x = EdgeInsets.all(48);

  /// Vertical Paddings
  /// verticalVeryLow2x => 4.h
  static const EdgeInsets verticalVeryLow2x = EdgeInsets.symmetric(vertical: 4);

  /// verticalVeryLow => 8.h
  static const EdgeInsets verticalVeryLow = EdgeInsets.symmetric(vertical: 8);

  /// verticalLow => 12.h
  static const EdgeInsets verticalLow = EdgeInsets.symmetric(vertical: 12);

  /// verticalMedium => 16.h
  static const EdgeInsets verticalMedium = EdgeInsets.symmetric(vertical: 16);

  /// verticalHigh => 24.h
  static const EdgeInsets verticalHigh = EdgeInsets.symmetric(vertical: 24);

  /// verticalVeryHigh => 32.h
  static const EdgeInsets verticalVeryHigh = EdgeInsets.symmetric(vertical: 32);

  /// verticalVeryHigh2x => 40.h
  static const EdgeInsets verticalVeryHigh2x = EdgeInsets.symmetric(
    vertical: 40,
  );

  /// verticalVeryHigh3x => 48.h
  static const EdgeInsets verticalVeryHigh3x = EdgeInsets.symmetric(
    vertical: 48,
  );

  /// Horizontal Paddings
  /// horizontalVeryLow2x => 4.w
  static const EdgeInsets horizontalVeryLow2x = EdgeInsets.symmetric(
    horizontal: 4,
  );

  /// horizontalVeryLow => 8.w
  static const EdgeInsets horizontalVeryLow = EdgeInsets.symmetric(
    horizontal: 8,
  );

  /// horizontalLow => 12.w
  static const EdgeInsets horizontalLow = EdgeInsets.symmetric(horizontal: 12);

  /// horizontalMedium => 16.w
  static const EdgeInsets horizontalMedium = EdgeInsets.symmetric(
    horizontal: 16,
  );

  /// horizontalHigh => 24.w
  static const EdgeInsets horizontalHigh = EdgeInsets.symmetric(horizontal: 24);

  /// horizontalVeryHigh => 32.w
  static const EdgeInsets horizontalVeryHigh = EdgeInsets.symmetric(
    horizontal: 32,
  );

  /// horizontalVeryHigh2x => 40.w
  static const EdgeInsets horizontalVeryHigh2x = EdgeInsets.symmetric(
    horizontal: 40,
  );

  /// horizontalVeryHigh3x => 48.w
  static const EdgeInsets horizontalVeryHigh3x = EdgeInsets.symmetric(
    horizontal: 48,
  );
}
