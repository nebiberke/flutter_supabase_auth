import 'package:flutter/material.dart';

/// A class that provides the path for the translations and the supported locales.
final class AppL10n {
  AppL10n._();

  /// The path for the translations.
  static const path = 'assets/translations';

  /// The English locale.
  static const en = Locale('en', 'US');

  /// The Turkish locale.
  static const tr = Locale('tr', 'TR');

  /// The supported locales.
  static List<Locale> get supportedLocales => [en, tr];
}
