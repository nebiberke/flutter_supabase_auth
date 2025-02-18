import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_state.dart';

/// Theme Cubit
class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  /// Takes a [Brightness] object and changes the theme
  ///
  /// If the brightness is [Brightness.dark] then the theme will be [ThemeMode.light]
  void changeTheme({required Brightness brightness}) {
    brightness == Brightness.dark
        ? emit(const ThemeState(themeMode: ThemeMode.light))
        : emit(const ThemeState(themeMode: ThemeMode.dark));
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    return ThemeState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return state.toMap();
  }
}
