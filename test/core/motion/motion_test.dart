import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/motion/count_up.dart';
import 'package:portfolio/core/motion/reveal.dart';

double _opacityOf(WidgetTester tester, Finder reveal) {
  final fade = tester.widget<FadeTransition>(
    find.descendant(of: reveal, matching: find.byType(FadeTransition)).first,
  );
  return fade.opacity.value;
}

Widget _page({required List<Widget> children, bool reduceMotion = false}) {
  return MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(
        size: const Size(800, 600),
        disableAnimations: reduceMotion,
      ),
      child: Scaffold(
        body: SingleChildScrollView(child: Column(children: children)),
      ),
    ),
  );
}

void main() {
  group('Reveal', () {
    testWidgets('reveals content that starts in view', (tester) async {
      await tester.pumpWidget(
        _page(
          children: const [Reveal(key: Key('top'), child: Text('top'))],
        ),
      );
      await tester.pumpAndSettle();
      expect(_opacityOf(tester, find.byKey(const Key('top'))), 1);
    });

    testWidgets('waits for off-screen content to scroll into view', (
      tester,
    ) async {
      await tester.pumpWidget(
        _page(
          children: const [
            SizedBox(height: 2000),
            Reveal(key: Key('below'), child: Text('below')),
          ],
        ),
      );
      await tester.pumpAndSettle();
      final below = find.byKey(const Key('below'));
      expect(_opacityOf(tester, below), 0);

      await tester.ensureVisible(below);
      await tester.pumpAndSettle();
      expect(_opacityOf(tester, below), 1);
    });

    testWidgets('shows everything at once when motion is reduced', (
      tester,
    ) async {
      await tester.pumpWidget(
        _page(
          reduceMotion: true,
          children: const [
            SizedBox(height: 2000),
            Reveal(key: Key('below'), child: Text('below')),
          ],
        ),
      );
      // A single frame, no settling: nothing may animate.
      expect(_opacityOf(tester, find.byKey(const Key('below'))), 1);
    });
  });

  group('CountUp', () {
    testWidgets('ends on the exact value, prefix and suffix kept', (
      tester,
    ) async {
      await tester.pumpWidget(
        _page(children: const [Reveal(child: CountUp('20K+'))]),
      );
      // The visible counter; an invisible copy of the final value only
      // reserves the size.
      String shown() => tester
          .widget<Text>(
            find.descendant(
              of: find.byType(Positioned),
              matching: find.byType(Text),
            ),
          )
          .data!;

      await tester.pump(const Duration(milliseconds: 100));
      expect(shown(), isNot('20K+'), reason: 'still counting');
      expect(shown(), endsWith('K+'));

      await tester.pumpAndSettle();
      expect(shown(), '20K+');
    });

    testWidgets('shows the value as is without a Reveal', (tester) async {
      await tester.pumpWidget(_page(children: const [CountUp('35%')]));
      expect(find.text('35%'), findsOneWidget);
    });

    testWidgets('announces the final value, even before revealing', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        _page(children: const [Reveal(child: CountUp('70'))]),
      );
      // First frame: not revealed yet, counter still at zero.
      expect(find.text('0'), findsOneWidget);
      expect(find.bySemanticsLabel('70'), findsOneWidget);
      semantics.dispose();
    });
  });
}
