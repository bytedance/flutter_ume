# flutter_ume_kit_console

[flutter_ume](https://pub.dev/packages/flutter_ume) 是由字节跳动 Flutter Infra 团队出品的应用内调试工具平台。

flutter_ume_kit_console 是 flutter_ume 的日志查看插件包。接入方式请见 [flutter_ume](https://pub.dev/packages/flutter_ume)。

如果使用 [logging](https://pub.dev/packages/logging)、[logger](https://pub.dev/packages/logger) 等日志库，可以调用 `consolePrint` 将日志输出到控制台。

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

If you are using packages like [logging](https://pub.dev/packages/logging) or [logger](https://pub.dev/packages/logger), you can call `consolePrint` to print logs to the console.

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
