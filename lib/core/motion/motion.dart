import 'package:flutter/widgets.dart';

/// Motion tokens. Short and ease-out everywhere: motion should confirm, not
/// perform.
abstract final class Motion {
  static const Duration hover = Duration(milliseconds: 180);
  static const Duration reveal = Duration(milliseconds: 600);
  static const Duration page = Duration(milliseconds: 220);

  /// Gap between items in a staggered group.
  static const Duration stagger = Duration(milliseconds: 70);

  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;

  /// Delay for item [index] in a staggered group, capped so long lists never
  /// make the visitor wait.
  static Duration staggerAt(int index, {int max = 5}) =>
      stagger * (index < max ? index : max);
}

extension MotionContext on BuildContext {
  /// True when the OS asks for reduced motion (`prefers-reduced-motion` on
  /// the web). Animations then jump straight to their end state.
  bool get reduceMotion => MediaQuery.disableAnimationsOf(this);
}
