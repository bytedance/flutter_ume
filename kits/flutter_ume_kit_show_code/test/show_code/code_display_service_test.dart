import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ume_kit_show_code/show_code/code_display_service.dart';

void main() {
  group('CodeDisplayService', () {
    test('getIdWithClassName', () async {
      final service = CodeDisplayService();
      final id = await service.getIdWithClassName('CodeDisplayService');
      expect(id, isNotNull);
    });
    test('getScriptIdWithFileName', () async {
      final service = CodeDisplayService();
      final id = await service.getScriptIdWithFileName('c');
      expect(id, isNotNull);
    });
    test('getScriptIdsWithKeyword', () async {
      final service = CodeDisplayService();
      final id = await service.getScriptIdsWithKeyword('c');
      expect(id, isA<Map>());
    });
    test('getSourceCodeWithScriptId', () async {
      final service = CodeDisplayService();
      final id = await service.getScriptIdWithFileName('c');
      expect(id, isNotNull);
      final sourceCode = await service.getSourceCodeWithScriptId(id!);
      expect(sourceCode, isNotNull);
    });
  });
}
