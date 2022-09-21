import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ume/core/ui/global.dart';
import 'package:flutter_ume_kit_device/components/cpu_info/cpu_info_page.dart';

import '../../mock_classes.dart';

void main() {
  group('CpuInfoPage', () {
    test('Pluggable', () {
      final pluggable = CpuInfoPage();
      final widget = pluggable.buildWidget(MockContext());
      final name = pluggable.name;
      final onTrigger = pluggable.onTrigger;
      onTrigger();
      final imageProvider = pluggable.iconImageProvider;

      expect(widget, isA<Widget>());
      expect(name, isNotEmpty);
      expect(onTrigger, isA<Function>());
      expect(imageProvider, isNotNull);
    });
    testWidgets('CpuInfoPage pump widget, Android', (tester) async {
      WidgetsFlutterBinding.ensureInitialized();

      final cpuInfoPage = CpuInfoPage(platform: MockAndroidPlatform());

      await tester.pumpWidget(MaterialApp(
          key: rootKey,
          home: Scaffold(
            body: cpuInfoPage,
          )));
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(cpuInfoPage, isNotNull);
    });
    testWidgets('CpuInfoPage pump widget, iOS', (tester) async {
      WidgetsFlutterBinding.ensureInitialized();

      final cpuInfoPage = CpuInfoPage(platform: MockIOSPlatform());

      await tester.pumpWidget(MaterialApp(
          key: rootKey,
          home: Scaffold(
            body: cpuInfoPage,
          )));
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(cpuInfoPage, isNotNull);
    });
  });
}
