import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ume_kit_console/console/show_date_time_style.dart';

void main() {
  group('ShowDateTimeStyle', () {
    test('styleById', () {
      final ids = [0, 1, 2, 3, 4];
      final styles = [
        ShowDateTimeStyle.datetime,
        ShowDateTimeStyle.time,
        ShowDateTimeStyle.timestamp,
        ShowDateTimeStyle.none,
        ShowDateTimeStyle.datetime
      ];
      for (final id in ids) {
        final style = styleById(id);
        expect(style, styles[ids.indexOf(id)]);
      }
    });

    test('idByStyle', () {
      final ids = [0, 1, 2, 3];
      final styles = [
        ShowDateTimeStyle.datetime,
        ShowDateTimeStyle.time,
        ShowDateTimeStyle.timestamp,
        ShowDateTimeStyle.none,
      ];
      for (final style in styles) {
        final id = idByStyle(style);
        expect(id, ids[styles.indexOf(style)]);
      }
    });
  });
}
