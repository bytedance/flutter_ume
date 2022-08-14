import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/mock_classes.dart';

void main() {
  group('StoreMixin', () {
    test('store and fetch bool', () async {
      SharedPreferences.setMockInitialValues({});

      final mockInstance = MockStoreMixinCls();
      await mockInstance.storeWithKey('test_key_bool', true);
      bool? value = await mockInstance.fetchWithKey('test_key_bool');
      expect(value, isA<bool>());
      expect(value, true);
    });

    test('store and fetch double', () async {
      SharedPreferences.setMockInitialValues({});

      final mockInstance = MockStoreMixinCls();
      await mockInstance.storeWithKey('test_key_double', double.maxFinite);
      double? value = await mockInstance.fetchWithKey('test_key_double');
      expect(value, isA<double>());
      expect(value, double.maxFinite);
    });

    test('store and fetch int', () async {
      SharedPreferences.setMockInitialValues({});

      final mockInstance = MockStoreMixinCls();
      await mockInstance.storeWithKey('test_key_int', 1);
      int? value = await mockInstance.fetchWithKey('test_key_int');
      expect(value, isA<int>());
      expect(value, 1);
    });

    test('store and fetch string', () async {
      SharedPreferences.setMockInitialValues({});

      final mockInstance = MockStoreMixinCls();
      await mockInstance.storeWithKey('test_key', 'test_key');
      String? value = await mockInstance.fetchWithKey('test_key');
      expect(value, isA<String>());
      expect(value, 'test_key');
    });

    test('store and fetch List<String>', () async {
      SharedPreferences.setMockInitialValues({});

      final mockInstance = MockStoreMixinCls();
      await mockInstance
          .storeWithKey('test_key_list', ['test_key', 'test_key']);
      List<String> value = await mockInstance.fetchWithKey('test_key_list');
      expect(value, isA<List<String>>());
      expect(value.length, 2);
    });
  });
}
