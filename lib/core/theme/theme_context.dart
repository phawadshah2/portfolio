import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_palette.dart';

extension ThemeContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;

  TextTheme get text => Theme.of(this).textTheme;
}
