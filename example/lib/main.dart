import 'package:dio/dio.dart';
import 'package:example/custom_router_pluggable.dart';
import 'package:example/detail_page.dart';
import 'package:example/home_page.dart';
import 'package:example/ume_switch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'package:flutter_ume_kit_ui/flutter_ume_kit_ui.dart';
import 'package:flutter_ume_kit_perf/flutter_ume_kit_perf.dart';
import 'package:flutter_ume_kit_show_code/flutter_ume_kit_show_code.dart';
import 'package:flutter_ume_kit_device/flutter_ume_kit_device.dart';
import 'package:flutter_ume_kit_console/flutter_ume_kit_console.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ume_kit_dio/flutter_ume_kit_dio.dart';

final Dio dio = Dio()..options = BaseOptions(connectTimeout: 10000);

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  if (kDebugMode) {
    PluginManager.instance
      ..register(WidgetInfoInspector())
      ..register(WidgetDetailInspector())
      ..register(ColorSucker())
      ..register(AlignRuler())
      ..register(ColorPicker())
      ..register(TouchIndicator())
      ..register(Performance())
      ..register(ShowCode())
      ..register(MemoryInfoPage())
      ..register(CpuInfoPage())
      ..register(DeviceInfoPanel())
      ..register(Console())
      ..register(DioInspector(dio: dio))
      ..register(CustomRouterPluggable());
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UMESwitch()),
        ],
        builder: (ctx, child) => UMEWidget(
          enable: ctx.watch<UMESwitch>().enable,
          child: MyApp(),
        ),
      ),
    );
  } else {
    runApp(MyApp());
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      CustomRouterPluggable().navKey = navigatorKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
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
