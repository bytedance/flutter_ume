import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ume/core/ui/icon_cache.dart';
import 'package:flutter_ume/core/pluggable_message_service.dart';
import 'package:flutter_ume/core/ui/panel_action_define.dart';
import 'package:flutter_ume/core/plugin_manager.dart';
import 'package:flutter_ume/core/red_dot.dart';
import 'package:flutter_ume/core/store_manager.dart';
import 'package:flutter_ume/core/pluggable.dart';
import 'package:flutter_ume/util/constants.dart';

class ToolBarWidget extends StatefulWidget {
  ToolBarWidget({Key? key, this.action, this.maximalAction, this.closeAction})
      : super(key: key);

  final MenuAction? action;
  final CloseAction? closeAction;
  final MaximalAction? maximalAction;

  @override
  _ToolBarWidgetState createState() => _ToolBarWidgetState();
}

const double _dragBarHeight = 32;
const double _minimalHeight = 80;

class _ToolBarWidgetState extends State<ToolBarWidget> {
  Size _windowSize = windowSize;
  double _dy = 0;

  @override
  void initState() {
    _dy = _windowSize.height - dotSize.height - bottomDistance;
    super.initState();
  }

  void _dragEvent(DragUpdateDetails details) {
    _dy += details.delta.dy;
    _dy = min(max(0, _dy),
        MediaQuery.of(context).size.height - _minimalHeight - _dragBarHeight);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_windowSize.isEmpty) {
      _dy =
          MediaQuery.of(context).size.height - dotSize.height - bottomDistance;
      _windowSize = MediaQuery.of(context).size;
    }
    return Positioned(
      left: 0,
      top: _dy,
      child: _ToolBarContent(
        action: widget.action,
        dragCallback: _dragEvent,
        maximalAction: widget.maximalAction,
        closeAction: widget.closeAction,
      ),
    );
  }
}

class _ToolBarContent extends StatefulWidget {
  _ToolBarContent(
      {Key? key,
      this.action,
      this.dragCallback,
      this.maximalAction,
      this.closeAction})
      : super(key: key);

  final MenuAction? action;
  final Function? dragCallback;
  final CloseAction? closeAction;
  final MaximalAction? maximalAction;

  @override
  __ToolBarContentState createState() => __ToolBarContentState();
}

class __ToolBarContentState extends State<_ToolBarContent> {
  PluginStoreManager _storeManager = PluginStoreManager();

  List<Pluggable?> _dataList = [];
  @override
  void initState() {
    super.initState();
    _handleData();
  }

  @override
  Widget build(BuildContext context) {
    const cornerRadius = Radius.circular(10);
    return Material(
      borderRadius:
          BorderRadius.only(topLeft: cornerRadius, topRight: cornerRadius),
      elevation: 20,
      child: Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.only(topLeft: cornerRadius, topRight: cornerRadius),
          color: Color(0xffd0d0d0),
        ),
        width: MediaQuery.of(context).size.width,
        height: _minimalHeight + _dragBarHeight,
        child: Column(
          children: [
            Container(
              height: _dragBarHeight,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          if (widget.closeAction != null) {
                            widget.closeAction!();
                          }
                        },
                        child: const CircleAvatar(
                          radius: 10,
                          backgroundColor: const Color(0xffff5a52),
                        )),
                    const SizedBox(
                      width: 8,
                    ),
                    InkWell(
                        onTap: () {
                          if (widget.maximalAction != null) {
                            widget.maximalAction!();
                          }
                        },
                        child: const CircleAvatar(
                          radius: 10,
                          backgroundColor: const Color(0xff53c22b),
                        )),
                    Expanded(
                      child: GestureDetector(
                        onVerticalDragUpdate: (details) =>
                            _dragCallback(details),
                        child: Container(
                          height: _dragBarHeight,
                          color: const Color(0xffd0d0d0),
                          child: Center(
                            child: Text(
                              'UME',
                              style: const TextStyle(
                                  color: Color(0xff575757),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _PluginScrollContainer(
              dataList: _dataList,
              action: widget.action,
            ),
          ],
        ),
      ),
    );
  }

  _dragCallback(DragUpdateDetails details) {
    if (widget.dragCallback != null) widget.dragCallback!(details);
  }

  void _handleData() async {
    List<Pluggable?> dataList = [];
    List<String>? list = await _storeManager.fetchStorePlugins();
    if (list == null || list.isEmpty) {
      dataList = PluginManager.instance.pluginsMap.values.toList();
    } else {
      list.forEach((f) {
        bool contain = PluginManager.instance.pluginsMap.containsKey(f);
        if (contain) {
          dataList.add(PluginManager.instance.pluginsMap[f]);
        }
      });
      PluginManager.instance.pluginsMap.keys.forEach((key) {
        if (!list.contains(key)) {
          dataList.add(PluginManager.instance.pluginsMap[key]);
        }
      });
    }
    _saveData(dataList);
    setState(() {
      _dataList = dataList;
    });
  }

  void _saveData(List<Pluggable?> data) {
    List l = data.map((f) => f!.name).toList();
    if (l.isEmpty) {
      return;
    }
    Future.delayed(Duration(milliseconds: 500), () {
      _storeManager.storePlugins(l as List<String>);
    });
  }
}

class _PluginScrollContainer extends StatelessWidget {
  _PluginScrollContainer({Key? key, required this.dataList, this.action})
      : super(key: key);

  final List<Pluggable?> dataList;
  final MenuAction? action;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: _minimalHeight,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: dataList
                  .map(
                    (data) => _MenuCell(
                      pluginData: data,
                      action: action,
                    ),
                  )
                  .toList(),
            )));
  }
}

class _MenuCell extends StatelessWidget {
  const _MenuCell({Key? key, this.pluginData, this.action}) : super(key: key);

  final Pluggable? pluginData;
  final MenuAction? action;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        PluggableMessageService().resetCounter(pluginData!);
        if (action != null) {
          action!(pluginData);
        }
      },
      child: Stack(
        children: [
          Container(
            height: _minimalHeight,
            width: _minimalHeight,
            color: Colors.white,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      child: IconCache.icon(pluggableInfo: pluginData!),
                      height: 28,
                      width: 28),
                  Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: Text(
                        pluginData!.name,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.black),
                        maxLines: 1,
                      ))
                ],
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: RedDot(
              pluginDatas: [pluginData],
            ),
          ),
        ],
      ),
    );
  }
}
