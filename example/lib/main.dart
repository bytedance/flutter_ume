import 'package:example/detail_page.dart';
import 'package:example/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ume/flutter_ume.dart';
// import 'package:flutter_ume_kit_ui/flutter_ume_kit_ui.dart';
// import 'package:flutter_ume_kit_perf/flutter_ume_kit_perf.dart';
// import 'package:flutter_ume_kit_show_code/flutter_ume_kit_show_code.dart';
// import 'package:flutter_ume_kit_device/flutter_ume_kit_device.dart';
// import 'package:flutter_ume_kit_console/flutter_ume_kit_console.dart';

void main() {
  if (kDebugMode) {
    PluginManager.instance
        // ..register(WidgetInfoInspector())
        // ..register(WidgetDetailInspector())
        // ..register(ColorSucker())
        // ..register(AlignRuler())
        // ..register(Performance())
        // ..register(ShowCode())
        // ..register(MemoryInfoPage())
        // ..register(CpuInfoPage())
        // ..register(DeviceInfoPanel())
        // ..register(Console())
        ;
    runApp(injectUMEWidget(child: MyApp(), enable: true));
  } else {
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UME Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'UME Demo Home Page'),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case 'detail':
            return MaterialPageRoute(
                builder: (BuildContext context) => DetailPage());
          default:
            return null;
        }
      },
    );
  }
}
