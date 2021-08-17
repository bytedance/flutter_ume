import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Counter App', () {
    final flutterLogoFinder = find.byTooltip('Open ume panel');

    late FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      driver.close();
    });

    test('Find tips', () async {
      final diagnostics = await driver.getWidgetDiagnostics(flutterLogoFinder);
      final properties = diagnostics['properties'] as List<dynamic>;
      bool findTip = false;
      for (final m in properties) {
        if (m['value'].toString() == "Open ume panel") {
          findTip = true;
          break;
        }
      }
      expect(findTip, isTrue);
    });

    test('Tap Flutter logo', () async {
      await driver.tap(flutterLogoFinder);
      expect(await driver.getText(find.text('UME')), 'UME');
    });

    test('Drag Flutter logo vertically', () async {
      await driver.runUnsynchronized(() async {
        const double dy = 100;
        await driver.waitFor(flutterLogoFinder);
        final oldPos = await driver.getBottomLeft(flutterLogoFinder);
        await driver.scroll(
            flutterLogoFinder, 0, -dy, Duration(milliseconds: 500));
        final newPos = await driver.getBottomLeft(flutterLogoFinder);
        expect((oldPos.dy - newPos.dy) - dy < 0.00001, true);
      });
    });

    test('Drag Flutter logo horizontally', () async {
      await driver.runUnsynchronized(() async {
        const double dx = 100;
        await driver.waitFor(flutterLogoFinder);
        final oldPos = await driver.getBottomLeft(flutterLogoFinder);
        await driver.scroll(
            flutterLogoFinder, -dx, 0, Duration(milliseconds: 500));
        final newPos = await driver.getBottomLeft(flutterLogoFinder);
        expect((oldPos.dx - newPos.dx) - dx < 0.00001, true);
      });
    });
  });
}
