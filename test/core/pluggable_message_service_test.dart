import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ume/core/pluggable_message_service.dart';
import 'package:flutter_ume/core/plugin_manager.dart';

import '../utils/mock_classes.dart';

void main() {
  group('PluggableMessageService.', () {
    PluggableMessageService? _service;
    MockPluggableWithStream? _plugin;

    setUp(() {
      _service = PluggableMessageService();
      _plugin = MockPluggableWithStream();
      PluginManager.instance!.register(_plugin!);
    });
    test('constructor', () {
      final service = _service;
      expect(service, isNotNull);
    });

    test('streamController type is instance of StreamController.', () {
      final streamController = _service!.messageStreamController;
      expect(streamController, isInstanceOf<StreamController>());
    });

    test(
        'pluggableMessageData is instance of <Map<String, PluggableMessageInfo>>.',
        () {
      final pluggableMessageData = _service!.pluggableMessageData;
      expect(pluggableMessageData,
          isInstanceOf<Map<String, PluggableMessageInfo>>());
    });

    test('A _plugin is registered just now, message count is 0.', () {
      final count = _service!.count(_plugin!);
      expect(count, 0);
    });
    test(
        'A _plugin is registered just now, increase counter, message count is 1.',
        () {
      _service!.resetListener();
      _service!.pluggableMessageData[_plugin!.name]!.increaseCounter();
      final count = _service!.count(_plugin!);
      expect(count, 1);
    });
    test(
        'A _plugin is registered just now, increase and reset counter, message count is 0.',
        () {
      _service!.resetListener();
      _service!.pluggableMessageData[_plugin!.name]!
        ..increaseCounter()
        ..resetCounter();
      final count = _service!.count(_plugin!);
      expect(count, 0);
    });
    test('A _plugin is registered just now, send a message.', () async {
      _service!.resetListener();
      _plugin!.streamController.sink.add('event');
      final count = _service!.count(_plugin!);
      expect(count, 0);
    });
    test('Increase counter, reset counter, count is 0.', () async {
      _service!.pluggableMessageData[_plugin!.name]!.increaseCounter();
      _service!.resetCounter(_plugin!);
      final count = _service!.count(_plugin!);
      expect(count, 0);
    });
    test('Increase counter, count all.', () async {
      _service!.pluggableMessageData[_plugin!.name]!.increaseCounter();
      final count = _service!.countAll([_plugin]);
      expect(count, 1);
    });

    test('PluggableMessage constructor, key.', () async {
      final pluggableMessage = PluggableMessage.create('key', 2);
      expect(pluggableMessage.key, 'key');
    });

    test('PluggableMessage constructor, counter.', () async {
      final pluggableMessage = PluggableMessage.create('key', 2);
      expect(pluggableMessage.count, 2);
    });
  });
}
