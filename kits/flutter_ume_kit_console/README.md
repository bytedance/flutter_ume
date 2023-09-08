# flutter_ume_kit_console

[flutter_ume](https://pub.dev/packages/flutter_ume) 是由字节跳动 Flutter Infra 团队出品的应用内调试工具平台。

flutter_ume_kit_console 是 flutter_ume 的日志查看插件包。接入方式请见 [flutter_ume](https://pub.dev/packages/flutter_ume)。

此插件无法直接监听 `print` 或 `developer.log`，需要使用 `debugPrint` 方法打印日志，或者结合 [logging](https://pub.dev/packages/logging)、[logger](https://pub.dev/packages/logger) 等日志库使用。

如果使用其他日志库，可以调用 `consolePrint` 将日志输出到应用内控制台。

```dart
// logging
Logger.root.onRecord.listen((record) {
  consolePrint(record.message);
});
```

```dart
// logger
class UmeConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      consolePrint(line);
    }
  }
}
```

----

[flutter_ume](https://pub.dev/packages/flutter_ume) is an in-app debug kits platform produced for Flutter apps by ByteDance Flutter Infra team.

flutter_ume_kit_console is the Console kits package of flutter_ume. Please visit [flutter_ume](https://pub.dev/packages/flutter_ume) for details.

This plugin cannot listen to `print` or `developer.log` directly. You need to use the `debugPrint` method to print logs, or use it with another log library such as [logging](https://pub.dev/packages/logging) or [logger](https://pub.dev/packages/logger).

If you use another log library, you can call `consolePrint` to print the log to the in-app console.

```dart
// logging
Logger.root.onRecord.listen((record) {
  consolePrint(record.message);
});
```

```dart
// logger
class UmeConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      consolePrint(line);
    }
  }
}
```
