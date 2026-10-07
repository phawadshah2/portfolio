import 'package:flutter/widgets.dart';

enum ScreenSize { mobile, tablet, desktop }

abstract final class Breakpoints {
  static const double tablet = 700;
  static const double desktop = 1080;

  /// Max width of the readable content column.
  static const double contentMaxWidth = 1120;

  static ScreenSize of(double width) {
    if (width >= desktop) return ScreenSize.desktop;
    if (width >= tablet) return ScreenSize.tablet;
    return ScreenSize.mobile;
  }
}

extension ScreenSizeContext on BuildContext {
  ScreenSize get screenSize => Breakpoints.of(MediaQuery.sizeOf(this).width);

  bool get isMobile => screenSize == ScreenSize.mobile;

  /// Horizontal page gutter for the current screen size.
  double get gutter => switch (screenSize) {
    ScreenSize.mobile => 20,
    ScreenSize.tablet => 32,
    ScreenSize.desktop => 48,
  };
}
