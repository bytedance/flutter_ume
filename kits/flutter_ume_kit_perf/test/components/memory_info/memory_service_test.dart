import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ume_kit_perf/components/memory_info/memory_service.dart';

void main() {
  group('Property', () {
    test('propertyStr isStatic', () {
      final p = Property(false, true, false, '', '');
      final result = p.propertyStr;
      expect(result, 'static      ');
    });

    test('propertyStr isConst', () {
      final p = Property(true, false, false, '', '');
      final result = p.propertyStr;
      expect(result, 'const      ');
    });

    test('propertyStr isFinal', () {
      final p = Property(false, false, true, '', '');
      final result = p.propertyStr;
      expect(result, 'final      ');
    });
  });

  group('ClsModel', () {
    test('ClsModel constructor', () {
      final m = ClsModel(propeties: [], functions: []);
      expect(m.functions, isList);
      expect(m.propeties, isList);
    });
  });
}
