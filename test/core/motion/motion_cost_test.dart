import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/widgets/surface_card.dart';
import 'package:portfolio/features/home/widgets/skills_section.dart';
import 'package:portfolio/features/home/widgets/work_section.dart';

import '../../helpers/pump_app.dart';

/// Guards the "animations stay cheap" promise: once an animation is running,
/// its frames may repaint but must never trigger layout.
void main() {
  /// Pumps [frames] frames and returns the render objects laid out meanwhile.
  Future<List<String>> layoutsDuring(WidgetTester tester, int frames) async {
    final layouts = <String>[];
    final original = debugPrint;
    debugPrint = (message, {wrapWidth}) {
      if (message != null) layouts.add(message);
    };
    debugPrintLayouts = true;
    try {
      for (var i = 0; i < frames; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
    } finally {
      debugPrintLayouts = false;
      debugPrint = original;
    }
    return layouts;
  }

  Future<TestGesture> hover(WidgetTester tester, Finder target) async {
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: Offset.zero);
    await tester.pump();
    await mouse.moveTo(tester.getCenter(target));
    // First frame applies the hover state; the animation runs after it.
    await tester.pump();
    return mouse;
  }

  testWidgets('card hover animates without layout', (tester) async {
    await tester.pumpApp();
    final card = find
        .descendant(
          of: find.byType(SkillsSection),
          matching: find.byType(SurfaceCard),
        )
        .first;
    await tester.ensureVisible(card);
    await tester.pumpAndSettle();

    await hover(tester, card);
    expect(await layoutsDuring(tester, 12), isEmpty);
  });

  testWidgets('project card lift animates without layout', (tester) async {
    await tester.pumpApp();
    final card = find.byType(ProjectCard);
    await tester.ensureVisible(card);
    await tester.pumpAndSettle();

    await hover(tester, card);
    expect(await layoutsDuring(tester, 12), isEmpty);
  });

  testWidgets('reveals and count-ups never lay out beyond the number', (
    tester,
  ) async {
    await tester.pumpApp();
    final skills = find.byType(SkillsSection);

    // Scroll in, then let the first frame start the reveals.
    await tester.ensureVisible(skills);
    await tester.pump();
    await tester.pump();

    // Count-ups re-lay out their own text each tick (a RenderParagraph and
    // the Align that bounds it). Anything else means layout leaked upward.
    final leaked = (await layoutsDuring(tester, 20)).where(
      (line) =>
          !line.contains('RenderParagraph') &&
          !line.contains('RenderPositionedBox'),
    );
    expect(leaked, isEmpty);
    await tester.pumpAndSettle();
  });
}
