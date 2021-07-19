import 'package:flutter/material.dart';
import 'package:system_info/system_info.dart';
import 'dart:convert';
import 'package:flutter_ume/flutter_ume.dart';
import 'icon.dart' as icon;
import 'package:platform/platform.dart';

class CpuInfoPage extends StatefulWidget implements Pluggable {
  CpuInfoPage({Key key, this.child, this.platform = const LocalPlatform()})
      : super(key: key);

  final Platform platform;

  final Widget child;

  @override
  _CpuInfoPageState createState() => _CpuInfoPageState();

  @override
  Widget buildWidget(BuildContext context) => this;

  @override
  String get name => 'CPUInfo';

  @override
  String get displayName => 'CPUInfo';

  @override
  void onTrigger() {}

  @override
  ImageProvider<Object> get iconImageProvider =>
      MemoryImage(base64Decode(icon.iconData));
}

class _CpuInfoPageState extends State<CpuInfoPage> {
  var _deviceInfo = <Map<String, String>>[];

  @override
  Widget build(BuildContext context) {
    if (!widget.platform.isAndroid)
      return Container(
        color: Colors.white,
        child: Center(
          child: Text('Only available on Android device'),
        ),
      );
    return Container(
      color: Colors.white,
      child: SafeArea(
          bottom: false,
          child: ListView.separated(
              itemBuilder: (ctx, index) => ListTile(
                    title: Text(_deviceInfo[index].keys.first),
                    trailing: Text(_deviceInfo[index].values.first),
                  ),
              separatorBuilder: (ctx, index) => Divider(),
              itemCount: _deviceInfo.length)),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.platform.isAndroid) _setupData();
  }

  _setupData() {
    const int MEGABYTE = 1024 * 1024;
    final deviceInfo = <Map<String, String>>[];
    deviceInfo.addAll([
      {'Kernel architecture': '${SysInfo.kernelArchitecture}'},
      {'Kernel bitness': '${SysInfo.kernelBitness}'},
      {'Kernel name': '${SysInfo.kernelName}'},
      {'Kernel version': '${SysInfo.kernelVersion}'},
      {'Operating system name': '${SysInfo.operatingSystemName}'},
      {'Operating system ': '${SysInfo.operatingSystemVersion}'},
      {'User directory': '${SysInfo.userDirectory}'},
      {'User id': '${SysInfo.userId}'},
      {'User name': '${SysInfo.userName}'},
      {'User space bitness': '${SysInfo.userSpaceBitness}'},
      {
        'Total physical memory':
            '${SysInfo.getTotalPhysicalMemory() ~/ MEGABYTE} MB'
      },
      {
        'Free physical memory':
            '${SysInfo.getFreePhysicalMemory() ~/ MEGABYTE} MB'
      },
      {
        'Total virtual memory':
            '${SysInfo.getTotalVirtualMemory() ~/ MEGABYTE} MB'
      },
      {
        'Free virtual memory':
            '${SysInfo.getFreeVirtualMemory() ~/ MEGABYTE} MB'
      },
      {
        'Virtual memory size':
            '${SysInfo.getVirtualMemorySize() ~/ MEGABYTE} MB'
      },
    ]);

    final processors = SysInfo.processors;
    deviceInfo.add(
      {'Number of processors': '${processors.length}'},
    );
    for (var processor in processors) {
      deviceInfo.addAll([
        {
          '[${processors.indexOf(processor)}] Architecture':
              '${processor.architecture}'
        },
        {'[${processors.indexOf(processor)}] Name': '${processor.name}'},
        {'[${processors.indexOf(processor)}] Socket': '${processor.socket}'},
        {'[${processors.indexOf(processor)}] Vendor': '${processor.vendor}'},
      ]);
    }
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _deviceInfo = deviceInfo;
      });
    });
  }
}
