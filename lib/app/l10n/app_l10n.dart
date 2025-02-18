import 'package:flutter/material.dart';

final class AppL10n {
  static const path = 'assets/translations';

  static const en = Locale('en', 'US');
  static const tr = Locale('tr', 'TR');

  static List<Locale> get supportedLocales => [en, tr];
}
