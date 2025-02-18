import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/app/constants/color_constants.dart';

enum SnackbarState {
  success(color: ColorConstants.success),
  error(color: ColorConstants.error),
  warning(color: ColorConstants.warning),
  info(color: ColorConstants.info);

  const SnackbarState({required this.color});
  final Color color;
}
