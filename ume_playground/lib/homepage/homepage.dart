import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ume_playground/components/info_container.dart';
import 'package:ume_playground/components/text_card_container.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const uiKitsImagesUrls = [
  r'assets/images/widget_info.png',
  r'assets/images/widget_detail.png',
  r'assets/images/color_picker.png',
  r'assets/images/align_ruler.png',
  r'assets/images/touch_indicator.png',
];

const perfKitsImagesUrls = [
  r'assets/images/perf_overlay.png',
  r'assets/images/memory_info.png',
];

const showCodeKitsImagesUrls = [
  r'assets/images/show_code.png',
];

const consoleKitsImagesUrls = [
  r'assets/images/console.png',
];

const deviceKitsImagesUrls = [
  r'assets/images/cpu_info.png',
  r'assets/images/device_info.png',
];

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer _timer;
  int _uiKitsImageIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _timer = Timer.periodic(const Duration(milliseconds: 4000), (value) {
        _updateImage();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _updateImage() {
    _uiKitsImageIndex = (_uiKitsImageIndex + 1) % uiKitsImagesUrls.length;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      // appBar: AppBar(
      //   // Here we take the value from the HomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title),
      // ),
      body: PageView(
        scrollDirection: Axis.vertical,
        children: [
          TextCardContainer(
              backgroundColor: Color(0xFFF0F0F0),
              title: '安全可靠的弹性计算服务',
              subtitle: '功能介绍',
              details: [
                Tuple3(Icons.category, l.deluxePlugins,
                    l.deluxePluginsDescription),
                Tuple3(Icons.blur_on_rounded, '开放插件平台',
                    '即开即用的云服务器，支持实时变更硬件规格，支持调整存储和网络配置，灵活适应不同的业务场景及需求'),
                Tuple3(Icons.code, '全部代码开源',
                    '即开即用的云服务器，支持实时变更硬件规格，支持调整存储和网络配置，灵活适应不同的业务场景及需求'),
              ]),
          InfoContainer(
              imageUrls: uiKitsImagesUrls, backgroundColor: Color(0xFFF9978F)),
          InfoContainer(
              imageUrls: perfKitsImagesUrls,
              backgroundColor: Color(0xFFFFFFFF)),
          InfoContainer(
              imageUrls: showCodeKitsImagesUrls,
              backgroundColor: Color(0xFFF0F0F0)),
          InfoContainer(
              imageUrls: consoleKitsImagesUrls,
              backgroundColor: Color(0xFFFFFFFF)),
          InfoContainer(
              imageUrls: deviceKitsImagesUrls,
              backgroundColor: Color(0xFFF0F0F0)),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
