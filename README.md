# flutter_ume

[简体中文](./README_cn.md)

UME is an in-app debug kits platform for Flutter apps.

[![platforms](https://img.shields.io/badge/platforms-ios%20%7C%20android%20%7C%20web%20%7C%20macos%20%7C%20windows%20%7C%20linux-lightgrey)](https://pub.dev/packages/flutter_ume) [![license](https://img.shields.io/github/license/bytedance/flutter_ume.svg)](https://github.com/bytedance/flutter_ume/blob/master/LICENSE)

[![pub package](https://img.shields.io/pub/v/flutter_ume.svg)](https://pub.dev/packages/flutter_ume)
[![pub package](https://img.shields.io/pub/likes/flutter_ume.svg)](https://pub.dev/packages/flutter_ume)
[![pub package](https://img.shields.io/pub/points/flutter_ume.svg)](https://pub.dev/packages/flutter_ume)
[![pub package](https://img.shields.io/pub/popularity/flutter_ume.svg)](https://pub.dev/packages/flutter_ume)
[![pub package](https://img.shields.io/pub/publisher/flutter_ume.svg)](https://pub.dev/packages/flutter_ume)

**Since `^1.0.0`, flutter_ume starts adapting to the Flutter 3. See [Quick Start] to learn more.**

<img src="https://github.com/bytedance/flutter_ume/raw/master/apk_qrcode.png" width = "128" height = "128" alt="banner" />

Scan QR code or click link to download apk. Try it now!
https://github.com/bytedance/flutter_ume/releases/download/v0.2.1.0/app-debug.apk

There are 13 plugin kits built in the latest open source version of UME.
Developer could create custom plugin kits, and integrate them into UME.
Visit [Develop plugin kits for UME](#develop-plugin-kits-for-ume) for more details.

**Please see [Plugins from community](#plugins-from-community) to make your flutter_ume stronger.**

- [flutter_ume](#flutter_ume)
  - [Quick Start](#quick-start)
  - [IMPORTANT](#important)
  - [Features](#features)
  - [Develop plugin kits for UME](#develop-plugin-kits-for-ume)
    - [Access the nested widget debug kits quickly](#access-the-nested-widget-debug-kits-quickly)
  - [How to use UME in Release/Profile mode](#how-to-use-ume-in-releaseprofile-mode)
  - [About version](#about-version)
    - [Compatibility](#compatibility)
    - [Coverage](#coverage)
    - [Version upgrade rules](#version-upgrade-rules)
    - [Null-safety](#null-safety)
    - [Change log](#change-log)
  - [Contributing](#contributing)
    - [Contributors](#contributors)
    - [Plugins from community](#plugins-from-community)
    - [About the third-party open-source project dependencies](#about-the-third-party-open-source-project-dependencies)
  - [LICENSE](#license)
  - [Contact the author](#contact-the-author)

## Quick Start

**All packages whose names are prefixed with `flutter_ume_kit_` are function**
**plug-ins of UME, and users can access them according to demand**

1. Edit `pubspec.yaml`, and add dependencies.

    **Compatible with Flutter 3 since version `1.0.0`.**

    ``` yaml
    dev_dependencies:
      flutter_ume: ^1.0.1
      flutter_ume_kit_ui: ^1.0.0
      flutter_ume_kit_device: ^1.0.0
      flutter_ume_kit_perf: ^1.0.0
      flutter_ume_kit_show_code: ^1.0.0
      flutter_ume_kit_console: ^1.0.0
      flutter_ume_kit_dio: ^1.0.0
    ```


    **↓ Null-safety version, compatible with Flutter 2.x**

    ``` yaml
    dev_dependencies: # Don't use UME in release mode
      flutter_ume: ^0.3.0+1
      flutter_ume_kit_ui: ^0.3.0+1
      flutter_ume_kit_device: ^0.3.0
      flutter_ume_kit_perf: ^0.3.0
      flutter_ume_kit_show_code: ^0.3.0
      flutter_ume_kit_console: ^0.3.0
      flutter_ume_kit_dio: ^0.3.0
    ```

    **↓ Non-null-safety version, compatible with Flutter 1.x**

    ``` yaml
    dev_dependencies: # Don't use UME in release mode
      flutter_ume: ^0.1.1
      flutter_ume_kit_ui: ^0.1.1
      flutter_ume_kit_device: ^0.1.1
      flutter_ume_kit_perf: ^0.1.1
      flutter_ume_kit_show_code: ^0.1.1
      flutter_ume_kit_console: ^0.1.1 
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
    import 'package:flutter_ume_kit_dio/flutter_ume_kit_dio.dart'; // Dio Inspector
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
          ..register(ColorPicker())                            // New feature
          ..register(TouchIndicator())                         // New feature
          ..register(Performance())
          ..register(ShowCode())
          ..register(MemoryInfoPage())
          ..register(CpuInfoPage())
          ..register(DeviceInfoPanel())
          ..register(Console())
          ..register(DioInspector(dio: dio));                  // Pass in your Dio instance
        // After flutter_ume 0.3.0
        runApp(UMEWidget(child: MyApp(), enable: true));
        // Before flutter_ume 0.3.0
        runApp(injectUMEWidget(child: MyApp(), enable: true));
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

**From `0.1.1`/`0.2.1` version，we don't need set `useRootNavigator: false`.**
The following section only applies to versions before version `0.1.1`/`0.2.1` .

<s>

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

</s>

## Features

There are 13 plugin kits built in the current open source version of UME.

<table border="1" width="100%">
    <tr>
        <td width="33.33%" align="center"><p>UI kits</p></td>
    </tr>
    <tr>
        <td width="33.33%" align="center"><img src="https://github.com/bytedance/flutter_ume/raw/master/screenshots/widget_info.png" width="100%" alt="Widget Info" /></br>Widget Info</td>
        <td width="33.33%" align="center"><img src="https://github.com/bytedance/flutter_ume/raw/master/screenshots/widget_detail.png" width="100%" alt="Widget Detail" /></br>Widget Detail</td>
        <td width="33.33%" align="center"><img src="https://github.com/bytedance/flutter_ume/raw/master/screenshots/align_ruler.png" width="100%" alt="Align Ruler" /></br>Align Ruler</td>
    </tr>
    <tr>
        <td width="33.33%" align="center"><img src="https://github.com/bytedance/flutter_ume/raw/master/screenshots/color_picker.png" width="100%" alt="Color Picker" /></br>Color Picker</td>
        <td width="33.33%" align="center"><img src="https://github.com/bytedance/flutter_ume/raw/master/screenshots/color_sucker.png" width="100%" alt="Color Sucker" /></br>Color Sucker</td>
        <td width="33.33%" align="center"><img src="https://github.com/bytedance/flutter_ume/raw/master/screenshots/touch_indicator.png" width="100%" alt="Touch Indicator" /></br>Touch Indicator</td>
    </tr>
    <tr>
        <td width="33.33%" align="center"></td>
    </tr>
    <tr>
        <td width="33.33%" align="center"><p>Performance Kits</p></td>
    </tr>
    <tr>
        <td width="33.33%" align="center"><img src="https://github.com/bytedance/flutter_ume/raw/master/screenshots/memory_info.png" width="100%" alt="Memory Info" /></br>Memory Info</td>
        <td width="33.33%" align="center"><img src="https://github.com/bytedance/flutter_ume/raw/master/screenshots/perf_overlay.png" width="100%" alt="Perf Overlay" /></br>Perf Overlay</td>
    </tr>
    <tr>
        <td width="33.33%" align="center"></td>
    </tr>
    <tr>
        <td width="33.33%" align="center"><p>Device Info Kits</p></td>
    </tr>
    <tr>
        <td width="33.33%" align="center"><img src="https://github.com/bytedance/flutter_ume/raw/master/screenshots/cpu_info.png" width="100%" alt="CPU Info" /></br>CPU Info</td>
        <td width="33.33%" align="center"><img src="https://github.com/bytedance/flutter_ume/raw/master/screenshots/device_info.png" width="100%" alt="Device Info" /></br>Device Info</td>
    </tr>
    <tr>
        <td width="33.33%" align="center"></td>
    </tr>
    <tr>
        <td width="33.33%" align="center"><p>Show Code</p></td>
    </tr>
    <tr>
        <td width="33.33%" align="center"><img src="https://github.com/bytedance/flutter_ume/raw/master/screenshots/show_code.png" width="100%" alt="Show Code" /></br>Show Code</td>
    </tr>
    <tr>
        <td width="33.33%" align="center"></td>
    </tr>
    <tr>
        <td width="33.33%" align="center"><p>Console</p></td>
    </tr>
    <tr>
        <td width="33.33%" align="center"><img src="https://github.com/bytedance/flutter_ume/raw/master/screenshots/console.png" width="100%" alt="Console" /></br>Console</td>
    </tr>
    <tr>
        <td width="33.33%" align="center"></td>
    </tr>
    <tr>
        <td width="33.33%" align="center"><p>Dio Inspector</p></td>
    </tr>
    <tr>
        <td width="33.33%" align="center"><img src="https://github.com/bytedance/flutter_ume/raw/master/screenshots/dio_inspector.png" width="100%" alt="Dio Inspector" /></br>Dio Inspector</td>
    </tr>
</table>

## Develop plugin kits for UME

> UME plugins are located in the `./kits` directory, and each one is a `package`.
> You can refer to the example in [`./custom_plugin_example`](./custom_plugin_example/) about this chapter.

1. Run `flutter create -t package custom_plugin` to create your custom plugin kit, it could be `package` or `plugin`.
2. Edit `pubspec.yaml` of the custom plugin kit to add UME framework dependency.

    ``` yaml
    dependencies:
      flutter_ume: '>=0.3.0 <0.4.0'
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
      String get displayName => 'CustomPlugin';

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
        UMEWidget(
          child: MyApp(), 
          enable: true
        )
      );
    } else {
      runApp(MyApp());
    }
    ```

6. Run your app

### Access the nested widget debug kits quickly

We introduce the `PluggableWithNestedWidget` from `0.3.0`. It is used to insert nested Widgets in the Widget tree and quickly access embedded kits with nested widget.

For more details, see [./kits/flutter_ume_kit_ui/lib/components/color_picker/color_picker.dart](https://github.com/bytedance/flutter_ume/blob/master/kits/flutter_ume_kit_ui/lib/components/color_picker/color_picker.dart) and [./kits/flutter_ume_kit_ui/lib/components/touch_indicator/touch_indicator.dart](https://github.com/bytedance/flutter_ume/blob/master/kits/flutter_ume_kit_ui/lib/components/touch_indicator/touch_indicator.dart).

The key steps are as follows:

1. The class of your plugin should implement `PluggableWithNestedWidget`.
2. Implements `Widget buildNestedWidget(Widget child)`. Handling the nested widgets and returning the new Widget.

## How to use UME in Release/Profile mode

**Once you use flutter_ume in Release/Profile mode, you agree that you will**
**bear the relevant risks by yourself.**

**The maintainer of flutter_ume does not assume any responsibility for the accident**
**caused by this.**

**We recommend not to use it in Release/Profile mode for the following reasons:**

1. VM Service is not available in these environments, so some functions are not available
2. In this environment, developers need to isolate the app distribution channels by themselves to avoid submitting relevant debugging code to the production environment

In order to use in Release/Profile mode, the details that need to be adjusted in the normal access process:

1. In `pubspec.yaml`, `flutter_ume` and plugins should be write below `dependencies` rather than `dev_dependencies`.
2. Don't put the code which call `PluginManager.instance.register()` and `UMEWidget(child: App())` into conditionals which represent debug mode. (Such as `kDebugMode`)
3. Ensure the above details, run `flutter clean` and `flutter pub get`, then build your app.

## About version

### Compatibility

| UME version | 1.12.13 | 1.22.3 | 2.0.1 | 2.2.3 | 2.5.3 | 2.8.0 | 3.0.5 | 3.3.1
| ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| 0.1.x | ✅ | ✅ | ✅ | ✅ | ⚠️ | ⚠️ | ❌ | ❌ |
| 0.2.x | ❌ | ❌ | ✅ | ✅ | ✅ | ⚠️ | ❌ | ❌ |
| 0.3.x | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| 1.0.x | ❌ | ❌ | ⚠️ | ⚠️ | ⚠️ | ⚠️ | ✅ | ✅ |
| 1.1.x | ❌ | ❌ | ⚠️ | ⚠️ | ⚠️ | ⚠️ | ✅ | ✅ |

⚠️ means the version has not been fully tested for compatibility.

### Special case

- Please use `flutter_ume_kit_ui: ^1.1.0` and above version when you are using Flutter 3.7 and above.

### Coverage

| Package | master | develop | develop_nullsafety |
| ---- | ---- | ---- | ---- |
| flutter_ume | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/master/coverage_badge.svg) | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/develop/coverage_badge.svg) | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/develop_nullsafety/coverage_badge.svg) |
| flutter_ume_kit_device | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/master/kits/flutter_ume_kit_device/coverage_badge.svg) | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/develop/kits/flutter_ume_kit_device/coverage_badge.svg) | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/develop_nullsafety/kits/flutter_ume_kit_device/coverage_badge.svg) |
| flutter_ume_kit_perf | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/master/kits/flutter_ume_kit_perf/coverage_badge.svg) | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/develop/kits/flutter_ume_kit_perf/coverage_badge.svg) | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/develop_nullsafety/kits/flutter_ume_kit_perf/coverage_badge.svg) |
| flutter_ume_kit_show_code | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/master/kits/flutter_ume_kit_show_code/coverage_badge.svg) | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/develop/kits/flutter_ume_kit_show_code/coverage_badge.svg) | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/develop_nullsafety/kits/flutter_ume_kit_show_code/coverage_badge.svg) |
| flutter_ume_kit_ui | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/master/kits/flutter_ume_kit_ui/coverage_badge.svg) | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/develop/kits/flutter_ume_kit_ui/coverage_badge.svg) | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/develop_nullsafety/kits/flutter_ume_kit_ui/coverage_badge.svg) |
| flutter_ume_kit_console | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/master/kits/flutter_ume_kit_console/coverage_badge.svg) | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/develop/kits/flutter_ume_kit_console/coverage_badge.svg) | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/develop_nullsafety/kits/flutter_ume_kit_console/coverage_badge.svg) |
| flutter_ume_kit_dio | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/master/kits/flutter_ume_kit_dio/coverage_badge.svg) | N/A | ![Coverage](https://raw.githubusercontent.com/bytedance/flutter_ume/develop_nullsafety/kits/flutter_ume_kit_dio/coverage_badge.svg) |

### Version upgrade rules

Please refer to [Semantic versions](https://dart.dev/tools/pub/versioning#semantic-versions) for details.

### Change log

[Changelog](./CHANGELOG.md)

## Contributing

Contributing rules: [Contributing](./CONTRIBUTING_en.md)

### Contributors

Thanks to the following contributors (names not listed in order)：

|  |  |
| ---- | ---- |
| ![ShirelyC](https://avatars.githubusercontent.com/u/11439167?s=64&v=4) | [ShirelyC](https://github.com/smileShirely) |
| ![lpylpyleo](https://avatars.githubusercontent.com/u/15264428?s=64&v=4) | [lpylpyleo](https://github.com/lpylpyleo) |
| ![Alex Li](https://avatars.githubusercontent.com/u/15884415?s=64&v=4) | [Alex Li](https://github.com/AlexV525) |
| ![Swain](https://avatars.githubusercontent.com/u/7621572?s=64&v=4) | [Swain](https://github.com/talisk) |
| ![mengdouer](https://avatars.githubusercontent.com/u/58758250?s=64&v=4) | [mengdouer](https://github.com/mengdouer) |
| ![LAIIIHZ](https://avatars.githubusercontent.com/u/35956195?s=64&v=4) | [LAIIIHZ](https://github.com/laiiihz) |
| ![XinLei](https://avatars.githubusercontent.com/u/23734225?s=64&v=4) | [XinLei](https://github.com/Vadaski) |
| ![suli](https://avatars.githubusercontent.com/u/5837645?s=64&v=4) | [suli](https://github.com/suli1) |
| ![wei-spring](https://avatars.githubusercontent.com/u/8155092?s=64&v=4) | [wei-spring](https://github.com/wei-spring) |

### Plugins from community

- [flutter_ume_kit_channel_monitor](https://pub.dev/packages/flutter_ume_kit_channel_monitor)
  - Channel communication monitor
  - Cource code: https://github.com/bytedance/flutter_ume/tree/master/kits/flutter_ume_kit_channel_monitor
- [flutter_ume_kit_slow_animation](https://pub.dev/packages/flutter_ume_kit_slow_animation)
  - Animation speed control
  - Cource code: https://github.com/cfug/flutter_ume_kits
- [flutter_ume_kit_shared_preferences](https://pub.dev/packages/flutter_ume_kit_shared_preferences)
  - shared_preferences tool
  - Cource code: https://github.com/cfug/flutter_ume_kits
- [flutter_ume_kit_designer_check](https://pub.dev/packages/)
  - Comparing tool for Design UI and real UI
  - Cource code: https://github.com/cfug/flutter_ume_kits
- [flutter_ume_kit_clean_local_data](https://pub.dev/packages/flutter_ume_kit_clean_local_data)
  - Clean local data
  - Cource code: https://github.com/cfug/flutter_ume_kits 。
- [flutter_ume_kit_database_kit](https://pub.dev/packages/flutter_ume_kit_database_kit)
  - DB tool
  - Cource code: https://github.com/cfug/flutter_ume_kits 。
- [ume_kit_monitor](https://pub.dev/packages/ume_kit_monitor)
  - Parameters monitor tools
  - Cource code: https://github.com/fastcode555/ume_kit_monitor 。
- [json2dart_viewerffi](https://pub.dev/packages/json2dart_viewerffi)
  - DB tool
  - Cource code: https://github.com/fastcode555/Json2Dart_Null_Safety 。
- [json2dart_viewer](https://pub.dev/packages/json2dart_viewer)
  - DB tool
  - Cource code: https://github.com/fastcode555/Json2Dart_Null_Safety 。
- [memory_detector_of_kit](https://github.com/bladeofgod/memory_detector_of_kit)
  - Leaks tool
- [channel_observer_of_kit](https://github.com/bladeofgod/channel_observer_of_kit)
  - Channel communication monitor
- [flutter-ume-kit-dio-enhance](https://github.com/linversion/flutter-ume-kit-dio-enhance)
  - Plugin base on flutter_ume_kit_dio

### About the third-party open-source project dependencies

- The TouchIndicator use the pub [touch_indicator](https://pub.dev/packages/touch_indicator), the ColorPicker use the pub [cyclop](https://pub.dev/packages/cyclop).
- We [fork](https://github.com/talisk/cyclop) the package [cyclop](https://pub.dev/packages/cyclop) and modify some code meet our functional needs. We should depend cyclop by pub version after the [PR](https://github.com/rxlabz/cyclop/pull/11) being merged.

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

Or contact [author](mailto:sunkai.dev@bytedance.com).
