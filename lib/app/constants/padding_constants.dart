import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A class that extends [EdgeInsets] to provide a more convenient way to set padding.
/// This class provides responsive padding values using Flutter ScreenUtil.
///
/// Example usage:
/// ```dart
/// Padding(padding: PaddingConstants.allHighLow());
/// ```
final class PaddingConstants extends EdgeInsets {
  const PaddingConstants.all(super.value) : super.all();

  /// Padinng All
  PaddingConstants.allVeryLow2x() : super.all(4.w);
  PaddingConstants.allVeryLow() : super.all(8.w);
  PaddingConstants.allLow() : super.all(12.w);
  PaddingConstants.allMedium() : super.all(16.w);
  PaddingConstants.allHigh() : super.all(24.w);
  PaddingConstants.allVeryHigh() : super.all(32.w);
  PaddingConstants.allVeryHigh2x() : super.all(40.w);
  PaddingConstants.allVeryHigh3x() : super.all(48.w);

  /// Padding Only Vertical
  PaddingConstants.verticalVeryLow2x() : super.symmetric(vertical: 4.h);
  PaddingConstants.verticalVeryLow() : super.symmetric(vertical: 8.h);
  PaddingConstants.verticalLow() : super.symmetric(vertical: 12.h);
  PaddingConstants.verticalMedium() : super.symmetric(vertical: 16.h);
  PaddingConstants.verticalHigh() : super.symmetric(vertical: 24.h);
  PaddingConstants.verticalVeryHigh() : super.symmetric(vertical: 32.h);
  PaddingConstants.verticalVeryHigh2x() : super.symmetric(vertical: 40.h);
  PaddingConstants.verticalVeryHigh3x() : super.symmetric(vertical: 48.h);

  /// Padding Only Horizontal
  PaddingConstants.horizontalVeryLow2x() : super.symmetric(horizontal: 4.w);
  PaddingConstants.horizontalVeryLow() : super.symmetric(horizontal: 8.w);
  PaddingConstants.horizontalLow() : super.symmetric(horizontal: 12.w);
  PaddingConstants.horizontalMedium() : super.symmetric(horizontal: 16.w);
  PaddingConstants.horizontalHigh() : super.symmetric(horizontal: 24.w);
  PaddingConstants.horizontalVeryHigh() : super.symmetric(horizontal: 32.w);
  PaddingConstants.horizontalVeryHigh2x() : super.symmetric(horizontal: 40.w);
  PaddingConstants.horizontalVeryHigh3x() : super.symmetric(horizontal: 48.w);
}
