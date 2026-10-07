import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/app/app.dart';

const desktopSize = Size(1440, 900);
const mobileSize = Size(390, 844);

extension PumpApp on WidgetTester {
  /// Pumps the full app at [location] with a logical screen of [size].
  Future<void> pumpApp({String location = '/', Size size = desktopSize}) async {
    view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(view.reset);
    await pumpWidget(PortfolioApp(initialLocation: location));
    await pumpAndSettle();
  }
}
