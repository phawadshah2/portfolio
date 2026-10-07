import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Holds the visitor's theme choice. Starts on [ThemeMode.system] so the site
/// follows the OS until the visitor picks a side.
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  /// Flips relative to what is currently *shown*, so the first tap always
  /// produces a visible change even while following the system setting.
  void toggle(Brightness current) {
    emit(current == Brightness.dark ? ThemeMode.light : ThemeMode.dark);
  }
}
