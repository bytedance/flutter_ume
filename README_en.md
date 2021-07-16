# flutter_ume

[简体中文](./README.md)

UME is an in-app debug kits platform for Flutter apps.

There are 10 plugin kits built in the current open source version of UME.
Developer could create custom plugin kits, and integrate them into UME.
Visit [Develop plugin kits for UME](#develop-plugin-kits-for-ume) for more details.

- [flutter_ume](#flutter_ume)
  - [Quick Start](#quick-start)
  - [IMPORTANT](#important)
  - [Features](#features)
  - [Develop plugin kits for UME](#develop-plugin-kits-for-ume)
  - [About version](#about-version)
    - [Compatibility](#compatibility)
    - [Coverage](#coverage)
    - [Version upgrade rules](#version-upgrade-rules)
    - [Change log](#change-log)
  - [How to contribute](#how-to-contribute)
  - [LICENSE](#license)
  - [Contact the author](#contact-the-author)

## Quick Start

1. Edit `pubspec.yaml`, and add dependencies.

    ``` yaml
    dev_dependencies: # Don't use UME in release mode
      flutter_ume: ^0.1.0
      flutter_ume_kit_ui: ^0.1.0
      flutter_ume_kit_device: ^0.1.0
      flutter_ume_kit_perf: ^0.1.0
      flutter_ume_kit_show_code: ^0.1.0
      flutter_ume_kit_console: ^0.1.0
    ```

2. Run `flutter pub get`
3. Import packages

    ``` dart
    import 'package:flutter_ume/flutter_ume.dart'; // UME framework
    import 'package:flutter_ume_kit_ui/flutter_ume_kit_ui.dart'; // UI kits
    import 'package:flutter_ume_kit_perf/flutter_ume_kit_perf.dart'; // Performance kits
    import 'package:flutter_ume_kit_show_code/flutter_ume_kit_show_code.dart'; // Show Code
    import 'package:flutter_ume_kit_device/flutter_ume_kit_device.dart'; // Device info
    import 'package:flutter_ume_kit_console/flutter_ume_kit_console.dart'; // Show debugPrint
    ```

4. Edit main method of your app, register plugin kits and initial UME

    ``` dart
    void main() {
      if (kDebugMode) {
        PluginManager.instance                                 // Register plugin kits
          ..register(WidgetInfoInspector())
          ..register(WidgetDetailInspector())
          ..register(ColorSucker())
          ..register(AlignRuler())
          ..register(Performance())
          ..register(ShowCode())
          ..register(MemoryInfoPage())
          ..register(CpuInfoPage())
          ..register(DeviceInfoPanel())
          ..register(Console());
        runApp(injectUMEWidget(child: MyApp(), enable: true)); // Initial UME
      } else {
        runApp(MyApp());
      }
    }
    ```

5. `flutter run` for running
   or `flutter build apk --debug`、`flutter build ios --debug` for building productions.

  > Some functions rely on VM Service, and additional parameters need to be added for local operation to ensure that it can connect to the VM Service.
  >
  > Flutter 2.0.x, 2.2.x and other versions run on real devices, `flutter run` needs to add the `--disable-dds` parameter.
  > After [Pull Request #80900](https://github.com/flutter/flutter/pull/80900) merging, `--disable-dds` was renamed to `--no-dds`.

## IMPORTANT

Since UME manages the routing stack at the top level, methods such as `showDialog` use `rootNavigator` to pop up by default,
therefore **must** pass in the parameter `useRootNavigator: false` in `showDialog`, `showGeneralDialog` and other 'show dialog' methods to avoid navigator errors.

``` dart
showDialog(
  context: context,
  builder: (ctx) => AlertDialog(
        title: const Text('Dialog'),
        actions: <Widget>[
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'))
        ],
      ),
  useRootNavigator: false); // <===== It's very IMPORTANT!
```

## Features

There are 10 plugin kits built in the current open source version of UME.

|  |  |  |  |  |
|  ----  | ----  | ----  | ----  | ----  |
| ![Widget Info](./screenshots/widget_info.png) | ![Widget Detail](./screenshots/widget_detail.png) | ![Color Sucker](./screenshots/color_sucker.png) | ![Align Ruler](./screenshots/align_ruler.png) | ![Perf Overlay](./screenshots/perf_overlay.png) |
| Widget Info | Widget Detail | Color Sucker | Align Ruler | Perf Overlay |
| ![Show Code](./screenshots/show_code.png) | ![Memory Info](./screenshots/memory_info.png) | ![CPU Info](./screenshots/cpu_info.png) | ![Device Info](./screenshots/device_info.png) | ![Console](./screenshots/console.png) |
| Show Code | Memory Info | CPU Info | Device Info | Console |

## Develop plugin kits for UME

> You can refer to the example in [`./custom_plugin_example`](./custom_plugin_example/) about this chapter.

1. Run `flutter create -t package custom_plugin` to create your custom plugin kit, it could be `package` or `plugin`.
2. Edit `pubspec.yaml` of the custom plugin kit to add UME framework dependency.

    ``` yaml
    dependencies:
      flutter_ume: '>=0.1.0 <0.2.0'
    ```

3. Create the class of the plugin kit which should implement `Pluggable`.

    ``` dart
    import 'package:flutter_ume/flutter_ume.dart';

    class CustomPlugin implements Pluggable {
      CustomPlugin({Key key});

      @override
      Widget buildWidget(BuildContext context) => Container(
        color: Colors.white
        width: 100,
        height: 100,
        child: Center(
          child: Text('Custom Plugin')
        ),
      ); // The panel of the plugin kit

      @override
      String get name => 'CustomPlugin'; // The name of the plugin kit

      @override
      void onTrigger() {} // Call when tap the icon of plugin kit

      @override
      ImageProvider<Object> get iconImageProvider => NetworkImage('url'); // The icon image of the plugin kit
    }
    ```

4. Use your custom plugin kit in project

    1. Edit `pubspec.yaml` of host app project to add `custom_plugin` dependency.

        ``` yaml
        dev_dependencies:
          custom_plugin:
            path: path/to/custom_plugin
        ```

    2. Run `flutter pub get`

    3. Import package

        ``` dart
        import 'package:custom_plugin/custom_plugin.dart';
        ```

5. Edit main method of your app, register your custom_plugin plugin kit

    ``` dart
    if (kDebugMode) {
      PluginManager.instance
        ..register(CustomPlugin());
      runApp(
        injectUMEWidget(
          child: MyApp(), 
          enable: true
        )
      );
    } else {
      runApp(MyApp());
    }
    ```

6. Run your app

## About version

### Compatibility

| UME version | Flutter 1.12.13 | Flutter 1.22.3 | Flutter 2.0.1 | Flutter 2.2.1 |
| ---- | ---- | ---- | ---- | ---- |
| 0.1.0 | ✅ | ✅ | ✅ | ✅ |

### Coverage

| Package | master | develop |
| flutter_ume | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/master/coverage_badge.svg) | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/develop/coverage_badge.svg) |
| flutter_ume_kit_device | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/master/kits/flutter_ume_kit_device/coverage_badge.svg) | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/develop/kits/flutter_ume_kit_device/coverage_badge.svg) |
| flutter_ume_kit_perf | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/master/kits/flutter_ume_kit_perf/coverage_badge.svg) | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/develop/kits/flutter_ume_kit_perf/coverage_badge.svg) |
| flutter_ume_kit_show_code | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/master/kits/flutter_ume_kit_show_code/coverage_badge.svg) | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/develop/kits/flutter_ume_kit_show_code/coverage_badge.svg) |
| flutter_ui_kit_ui | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/master/kits/flutter_ui_kit_ui/coverage_badge.svg) | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/develop/kits/flutter_ui_kit_ui/coverage_badge.svg) |
| flutter_ui_kit_console | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/master/kits/flutter_ui_kit_console/coverage_badge.svg) | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/develop/kits/flutter_ui_kit_console/coverage_badge.svg) |

### Version upgrade rules

Please refer to [Semantic versions](https://dart.dev/tools/pub/versioning#semantic-versions) for details.

### Change log

[Changelog](./CHANGELOG_en.md)

## How to contribute

[Contributing](./CONTRIBUTING_en.md)

## LICENSE

This project is licensed under the MIT License - visit the [LICENSE](./LICENSE) for details.

## Contact the author

**Maybe...**

- Found a bug in the code, or an error in the documentation
- Produces an exception when you use the UME
- UME is not compatible with the new version Flutter
- Have a good idea or suggestion

You can [submit an issue](./CONTRIBUTING_en.md#how-to-raise-an-issue) in any of the above situations.

**Maybe...**

- Communicate with the author
- Communicate with more community developers
- Cooperate with UME

Welcome to [Join the ByteDance Flutter Exchange Group](https://applink.feishu.cn/client/chat/chatter/add_by_link?link_token=67au2f75-3783-41b0-8868-0fc0178f1fd8).

Or contact [author](mailto:zhaorui.dev@bytedance.com).
