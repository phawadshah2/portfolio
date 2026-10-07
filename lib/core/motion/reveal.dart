import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:portfolio/core/motion/motion.dart';

/// Fades and lifts [child] into place the first time it scrolls into view.
///
/// Performance notes:
/// * Only opacity and translation animate. Both are paint/compositing
///   operations, so no layout runs per frame.
/// * The scroll listener is removed as soon as the widget reveals, so a
///   fully revealed page does zero work while scrolling.
/// * Descendants can follow the same animation through [Reveal.of] (e.g. a
///   count-up) instead of running controllers of their own.
class Reveal extends StatefulWidget {
  const Reveal({
    required this.child,
    this.delay = Duration.zero,
    this.offset = 24,
    super.key,
  });

  final Widget child;
  final Duration delay;

  /// Distance in logical pixels the child rises while fading in.
  final double offset;

  /// The nearest enclosing reveal animation, or null when there is none.
  static Animation<double>? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_RevealScope>()?.animation;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  /// Reveal once the top edge passes this fraction of the viewport height.
  static const _threshold = 0.92;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Motion.reveal,
  );
  late final Animation<double> _progress = CurvedAnimation(
    parent: _controller,
    curve: Motion.enter,
  );

  ScrollPosition? _position;
  Timer? _delay;
  bool _triggered = false;
  bool _checkScheduled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_triggered) return;

    if (context.reduceMotion) {
      _triggered = true;
      _controller.value = 1;
      _detach();
      return;
    }

    final position = Scrollable.maybeOf(context)?.position;
    if (position != _position) {
      _detach();
      _position = position?..addListener(_scheduleCheck);
    }
    // Depending on the viewport size re-runs this on resize, so content that
    // a larger window exposes gets revealed without needing a scroll.
    MediaQuery.sizeOf(context);
    _scheduleCheck();
  }

  /// Scroll notifications fire before the viewport re-lays out, when this
  /// box still reports its old position. Checking after the frame reads the
  /// real one, and coalesces a burst of scroll events into one check.
  void _scheduleCheck() {
    if (_checkScheduled || _triggered) return;
    _checkScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkScheduled = false;
      _check();
    });
  }

  void _check() {
    if (_triggered || !mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return;

    final top = box.localToGlobal(Offset.zero).dy;
    final height = MediaQuery.sizeOf(context).height;
    // Content near the end of the page may never get past the threshold
    // because there is nothing left to scroll; once at the bottom, anything
    // on screen counts as seen.
    final atEnd = _position?.extentAfter == 0;
    final seen = top < height * _threshold || (atEnd && top < height);
    if (!seen) return;

    _triggered = true;
    _detach();
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      _delay = Timer(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  void _detach() {
    _position?.removeListener(_scheduleCheck);
    _position = null;
  }

  @override
  void dispose() {
    _delay?.cancel();
    _detach();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _RevealScope(
      animation: _progress,
      child: FadeTransition(
        opacity: _progress,
        // Hidden-until-scrolled is a visual effect only: screen readers must
        // still reach content the visitor has not scrolled to.
        alwaysIncludeSemantics: true,
        child: AnimatedBuilder(
          animation: _progress,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, (1 - _progress.value) * widget.offset),
            child: child,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class _RevealScope extends InheritedWidget {
  const _RevealScope({required this.animation, required super.child});

  final Animation<double> animation;

  @override
  bool updateShouldNotify(_RevealScope oldWidget) =>
      animation != oldWidget.animation;
}

/// A start-aligned [Column] whose children reveal one after another.
/// Spacers ([SizedBox]) are passed through untouched and don't use up a
/// stagger step.
class RevealColumn extends StatelessWidget {
  const RevealColumn({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    var step = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final child in children)
          if (child is SizedBox)
            child
          else
            Reveal(delay: Motion.staggerAt(step++), offset: 16, child: child),
      ],
    );
  }
}
