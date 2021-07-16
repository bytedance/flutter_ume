import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'package:flutter_ume_kit_console/console/console_manager.dart';
import 'package:flutter_ume_kit_console/console/icon.dart' as icon;
import 'package:flutter_ume/util/floating_widget.dart';
import 'package:flutter_ume/util/store_mixin.dart';
import 'package:flutter_ume_kit_console/console/show_date_time_style.dart';

class Console extends StatefulWidget implements PluggableWithStream {
  Console({Key key}) {
    ConsoleManager.redirectDebugPrint();
  }

  @override
  ConsoleState createState() => ConsoleState();

  @override
  Widget buildWidget(BuildContext context) => this;

  @override
  ImageProvider<Object> get iconImageProvider =>
      MemoryImage(base64Decode(icon.iconData));

  @override
  String get name => 'Console';

  @override
  void onTrigger() {}

  @override
  Stream get stream => ConsoleManager.streamController.stream;

  @override
  StreamFilter get streamFilter => (e) => true;
}

class ConsoleState extends State<Console>
    with WidgetsBindingObserver, StoreMixin {
  List<Tuple2<DateTime, String>> _logList = <Tuple2<DateTime, String>>[];
  StreamSubscription _subscription;
  ScrollController _controller;
  ShowDateTimeStyle _showDateTimeStyle;
  bool _showFilter = false;
  RegExp _filterExp;

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _controller = null;
    _showDateTimeStyle = ShowDateTimeStyle.datetime;
    _showFilter = false;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchWithKey('console_panel_datetime_style').then((value) async {
      if (value != null && value is int) {
        _showDateTimeStyle = styleById(value);
      } else {
        _showDateTimeStyle = ShowDateTimeStyle.datetime;
        await storeWithKey(
            'console_panel_datetime_style', idByStyle(_showDateTimeStyle));
      }
      setState(() {});
    });
    _controller = ScrollController();
    _logList = ConsoleManager.logData.toList();
    _subscription = ConsoleManager.streamController.stream.listen((onData) {
      if (mounted) {
        if (_filterExp != null) {
          _logList = ConsoleManager.logData.where((e) {
            return _filterExp.hasMatch(e.item1.toString()) ||
                _filterExp.hasMatch(e.item2);
          }).toList();
        } else {
          _logList = ConsoleManager.logData.toList();
        }

        setState(() {});
        _controller.jumpTo(
            _controller.position.maxScrollExtent + 22); // 22 is a magic number
      }
    });
  }

  void _refreshConsole() {
    if (_filterExp != null) {
      _logList = ConsoleManager.logData.where((e) {
        return _filterExp.hasMatch(e.item1.toString()) ||
            _filterExp.hasMatch(e.item2);
      }).toList();
    } else {
      _logList = ConsoleManager.logData.toList();
    }
  }

  String _dateTimeString(int logIndex) {
    String result = '';
    switch (_showDateTimeStyle) {
      case ShowDateTimeStyle.datetime:
        result =
            '${_logList[_logList.length - logIndex - 1].item1.toString().padRight(26, '0')}';
        break;
      case ShowDateTimeStyle.time:
        result =
            '${_logList[_logList.length - logIndex - 1].item1.toString().padRight(26, '0')}'
                .substring(11);
        break;
      case ShowDateTimeStyle.timestamp:
        result =
            '${_logList[_logList.length - logIndex - 1].item1.millisecondsSinceEpoch}';
        break;
      case ShowDateTimeStyle.none:
        result = '';
        break;
      default:
        break;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingWidget(
      contentWidget: Container(
          color: Colors.black,
          child: Stack(children: [
            ListView.builder(
              controller: _controller,
              itemCount: _logList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 3, bottom: 3),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: _dateTimeString(index),
                          style: TextStyle(
                            color: Colors.white60,
                            fontFamily: 'Courier',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          )),
                      TextSpan(
                          text:
                              '${_logList[_logList.length - index - 1].item2}',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Courier',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          )),
                    ]),
                  ),
                );
              },
            ),
            if (_showFilter)
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Container(
                  child: TextField(
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        _filterExp = RegExp(value);
                      } else {
                        _filterExp = null;
                      }
                      setState(() {});
                      _refreshConsole();
                    },
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'RegExp',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                      contentPadding: EdgeInsets.only(
                        top: 0,
                        bottom: 0,
                      ),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
          ])),
      toolbarActions: [
        Tuple3(
            'Style',
            Icon(
              Icons.access_time,
              size: 20,
            ),
            _triggerShowDate),
        Tuple3(
            'Clear',
            Icon(
              Icons.do_not_disturb,
              size: 20,
            ),
            () => ConsoleManager.clearLog()),
        Tuple3(
            'Filter',
            Icon(
              Icons.search,
              size: 20,
            ),
            _triggerFilter),
        Tuple3(
            'Share',
            Icon(
              Icons.share,
              size: 20,
            ),
            _share),
      ],
    );
  }

  void _triggerShowDate() async {
    _showDateTimeStyle = styleById((idByStyle(_showDateTimeStyle) + 1) % 4);
    await storeWithKey(
        'console_panel_datetime_style', idByStyle(_showDateTimeStyle));
    setState(() {});
  }

  void _triggerFilter() {
    setState(() {
      _showFilter = !_showFilter;
      if (!_showFilter) {
        _filterExp = null;
      }
    });
    _refreshConsole();
  }

  Future<void> _share() async {
    if (_logList == null || _logList.isEmpty) {
      return;
    }
    final l = _logList.map((e) => '${e.item1.toString()} ${e.item2}').toList();
    return Share.share("${l.join('\n')}");
  }
}
