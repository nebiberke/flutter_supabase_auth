part of 'theme_cubit.dart';

/// The state of the theme
final class ThemeState extends Equatable {
  const ThemeState({this.themeMode = ThemeMode.system});

  /// Takes a [Map] and returns a [ThemeState] object
  factory ThemeState.fromMap(Map<String, dynamic> map) {
    return ThemeState(themeMode: ThemeMode.values[map['themeMode'] as int]);
  }

  /// The theme mode
  final ThemeMode themeMode;

  /// Takes a [ThemeState] object and returns a [Map]
  Map<String, dynamic> toMap() {
    return {'themeMode': themeMode.index};
  }

  @override
  List<Object> get props => [themeMode];
}
