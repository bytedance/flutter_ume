import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_ume/core/ui/global.dart';
import 'package:flutter_ume_kit_console/console/console_manager.dart';
import 'package:flutter_ume_kit_console/flutter_ume_kit_console.dart';

import '../mock_classes.dart';

void main() {
  group('ConsoleManager', () {
    test('Queue getter', () {
      final queue = ConsoleManager.logData;
      expect(queue, isA<Queue<Tuple2<DateTime, String>>>());
      expect(queue, isNotNull);
    });

    test('StreamController getter', () {
      final streamController = ConsoleManager.streamController;
      expect(streamController, isA<StreamController>());
      expect(streamController, isNotNull);
    });

    test('redirectDebugPrint, print String', () async {
      ConsoleManager.redirectDebugPrint();
      debugPrint('ONLY FOR TESTING');
      await Future.delayed(const Duration(seconds: 1), () {});

      final lastLog = ConsoleManager.logData.last.item2;
      expect(lastLog, 'ONLY FOR TESTING');
      ConsoleManager.clearRedirect();
    });

    test('redirectDebugPrint, count of elements over max', () async {
      ConsoleManager.redirectDebugPrint();
      for (int i = 0; i < 1000; ++i) {
        ConsoleManager.logData.add(Tuple2(DateTime.now(), '$i'));
      }
      debugPrint('ONLY FOR TESTING');
      await Future.delayed(const Duration(seconds: 1), () {});

      expect(ConsoleManager.logData.length, 1000);
      final lastLog = ConsoleManager.logData.first.item2;
      expect(lastLog, 'ONLY FOR TESTING');
      ConsoleManager.clearRedirect();
    });

    test('redirectDebugPrint, clearLog', () async {
      ConsoleManager.redirectDebugPrint();
      for (int i = 0; i < 1000; ++i) {
        ConsoleManager.logData.add(Tuple2(DateTime.now(), '$i'));
      }
      ConsoleManager.clearLog();
      await Future.delayed(const Duration(seconds: 1), () {});
      expect(ConsoleManager.logData.length, 1);
      ConsoleManager.clearRedirect();
    });
  });
}
