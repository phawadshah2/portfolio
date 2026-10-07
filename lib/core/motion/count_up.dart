import 'package:flutter/material.dart';
import 'package:portfolio/core/motion/reveal.dart';

/// Counts the number inside [value] up from zero, in step with the enclosing
/// [Reveal]. Prefix and suffix are kept: `20K+` counts 0K+ → 20K+.
///
/// Without an enclosing [Reveal], or when [value] has no number, the final
/// text is shown as is.
class CountUp extends StatelessWidget {
  const CountUp(this.value, {this.style, super.key});

  static final _number = RegExp(r'^(\D*)(\d+)(.*)$');

  final String value;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    // Tabular figures keep every digit the same width, so the text does not
    // jitter while the number changes.
    final textStyle = (style ?? const TextStyle()).copyWith(
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    final animation = Reveal.of(context);
    final match = _number.firstMatch(value);
    if (animation == null || match == null) {
      return Text(value, style: textStyle);
    }

    final prefix = match.group(1)!;
    final target = int.parse(match.group(2)!);
    final suffix = match.group(3)!;
    return Semantics(
      // Screen readers get the final value, not every intermediate frame.
      label: value,
      excludeSemantics: true,
      child: Stack(
        children: [
          // The final value, invisible, fixes the size up front...
          Visibility.maintain(
            visible: false,
            child: Text(value, style: textStyle),
          ),
          // ...so the counting text gets tight constraints. That makes it a
          // relayout boundary: each tick lays out this text alone, not the
          // page above it.
          Positioned.fill(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, _) => Text(
                  '$prefix${(target * animation.value).round()}$suffix',
                  style: textStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
