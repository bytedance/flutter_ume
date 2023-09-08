import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ume/flutter_ume.dart';

class CustomLog implements Pluggable {

  @override
  Widget? buildWidget(BuildContext? context) => _buildLogPanel(context);

  @override
  ImageProvider<Object> get iconImageProvider => MemoryImage(base64Decode(
      r'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'));

  @override
  String get name => 'CustomLog';

  @override
  String get displayName => 'CustomLog';

  @override
  void onTrigger() {
    debugPrint('$name onTrigger');
  }

  static List<String> _logList = <String>[];
  static List<String> get logList => _logList;

  static void log(String info) {
    _logList.add(info);
    print(info);
  }

  Widget _buildLogPanel(BuildContext? context) {
    if (context == null) return Container();
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: LogViewerPage()),
    );
  }
}

class LogViewerPage extends StatefulWidget {
  LogViewerPage({Key? key}) : super(key: key);

  @override
  _LogViewerPageState createState() => _LogViewerPageState();
}

class _LogViewerPageState extends State<LogViewerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CustomLog Viewer'),
      ),
      body: ListView.separated(
          itemBuilder: (ctx, index) {
            return ListTile(
              title: Text('${CustomLog.logList[index]}'),
            );
          },
          separatorBuilder: (ctx, index) => Divider(),
          itemCount: CustomLog.logList.length),
    );
  }
}
