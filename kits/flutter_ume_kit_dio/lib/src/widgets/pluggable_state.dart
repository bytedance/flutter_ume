///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/6 11:25
///
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../instances.dart';
import '../pluggable.dart';

const JsonEncoder _encoder = JsonEncoder.withIndent('  ');

ButtonStyle _buttonStyle(
  BuildContext context, {
  EdgeInsetsGeometry? padding,
}) {
  return TextButton.styleFrom(
    padding: padding ?? const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
    minimumSize: Size.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(999999),
    ),
    backgroundColor: Theme.of(context).primaryColor,
    primary: Colors.white,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );
}

class DioPluggableState extends State<DioPluggable> {
  // Widget _backdrop(BuildContext context) {
  //   return Positioned.fill(
  //     child: GestureDetector(
  //       onTap: () {
  //         InspectorInstance.fabKey.currentState?.switchPanel();
  //       },
  //       child: const ColoredBox(color: Colors.black26),
  //     ),
  //   );
  // }

  Widget _clearAllButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        InspectorInstance.httpContainer.clearRequests();
        setState(() {});
      },
      style: _buttonStyle(
        context,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 3,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          Text('清空'),
          Icon(Icons.cleaning_services, size: 14),
        ],
      ),
    );
  }

  Widget _itemList(BuildContext context) {
    final int length = InspectorInstance.httpContainer.requests.length;
    if (length > 0) {
      return CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, int index) => _ResponseCard(
                key: ValueKey<int>(index),
                response: InspectorInstance.httpContainer.requests[index],
              ),
              childCount: length,
              findChildIndexCallback: (Key key) => (key as ValueKey<int>).value,
            ),
          ),
        ],
      );
    }
    return const Center(
      child: Text(
        'Come back later...\n🧐',
        style: TextStyle(fontSize: 28),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black26,
      child: DefaultTextStyle.merge(
        style: Theme.of(context).textTheme.bodyText2,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            constraints: BoxConstraints.tightFor(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height / 1.25,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              color: Theme.of(context).cardColor,
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: <Widget>[
                      const Spacer(),
                      Text(
                        '网络请求',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: _clearAllButton(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ColoredBox(
                    color: Theme.of(context).canvasColor,
                    child: _itemList(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResponseCard extends StatefulWidget {
  const _ResponseCard({
    required Key? key,
    required this.response,
  }) : super(key: key);

  final Response<dynamic> response;

  @override
  _ResponseCardState createState() => _ResponseCardState();
}

class _ResponseCardState extends State<_ResponseCard> {
  final ValueNotifier<bool> _isExpanded = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isExpanded.dispose();
    super.dispose();
  }

  void _switchExpand() {
    _isExpanded.value = !_isExpanded.value;
  }

  Response<dynamic> get response => widget.response;

  RequestOptions get request => response.requestOptions;

  /// 请求开始时间
  DateTime get startTime => request.extra['startTime'] as DateTime;

  /// 请求结束时间
  DateTime get endTime => request.extra['endTime'] as DateTime;

  /// 请求时长
  Duration get duration => endTime.difference(startTime);

  /// 状态码
  int get statusCode => response.statusCode ?? 0;

  /// 状态码对应的颜色
  Color get statusColor {
    if (statusCode >= 200 && statusCode < 300) {
      return Colors.lightGreen;
    } else if (statusCode >= 300 && statusCode < 400) {
      return Colors.orangeAccent;
    } else if (statusCode >= 400 && statusCode < 500) {
      return Colors.purple;
    } else if (statusCode >= 500 && statusCode < 600) {
      return Colors.red;
    }
    return Colors.blueAccent;
  }

  /// 请求方法
  String get method => request.method;

  /// 请求的 Uri
  Uri get requestUri => request.uri;

  /// 重定向后的 Uri
  Uri get realUri => response.realUri;

  /// 返回内容长度
  int get responseContentLength {
    return int.tryParse(
          response.headers[Headers.contentLengthHeader]?.elementAt(0) ?? '0',
        ) ??
        0;
  }

  /// 返回的内容类型
  String get responseContentType {
    return response.headers[Headers.contentTypeHeader]?.elementAt(0) ?? 'null';
  }

  /// 请求体内容
  String? get requestDataBuilder {
    if (request.data != null && request.data is Map) {
      return _encoder.convert(request.data);
    }
    return request.data?.toString();
  }

  String get responseDataBuilder {
    if (response.data != null && response.data is Map) {
      return _encoder.convert(response.data);
    }
    return response.data.toString();
  }

  Widget _detailButton(BuildContext context) {
    return TextButton(
      onPressed: _switchExpand,
      style: _buttonStyle(context),
      child: const Text(
        '查看详情🔍',
        style: TextStyle(fontSize: 12, height: 1.2),
      ),
    );
  }

  Widget _infoContent(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(startTime.hms()),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 1,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: statusColor,
          ),
          child: Text(
            statusCode.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          method,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 6),
        Text('${duration.inMilliseconds}ms'),
        const Spacer(),
        _detailButton(context),
      ],
    );
  }

  Widget _detailedContent(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isExpanded,
      builder: (_, bool value, __) {
        if (!value) {
          return const SizedBox.shrink();
        }
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (requestDataBuilder != null)
                _TagText(tag: 'Request data', content: requestDataBuilder!),
              _TagText(tag: 'Response body', content: responseDataBuilder),
              _TagText(
                tag: 'Response headers',
                content: '\n${response.headers}',
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shadowColor: Theme.of(context).canvasColor,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _infoContent(context),
            const SizedBox(height: 10),
            _TagText(tag: 'Uri', content: '$requestUri'),
            _detailedContent(context),
          ],
        ),
      ),
    );
  }
}

class _TagText extends StatelessWidget {
  const _TagText({
    Key? key,
    required this.tag,
    required this.content,
    this.selectable = true,
  }) : super(key: key);

  final String tag;
  final String content;
  final bool selectable;

  TextSpan get span {
    return TextSpan(
      children: <TextSpan>[
        TextSpan(
          text: '$tag: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(text: content.notBreak),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget text;
    if (selectable) {
      text = SelectableText.rich(span);
    } else {
      text = Text.rich(span);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: text,
    );
  }
}

extension _StringExtension on String {
  String get notBreak => Characters(this).toList().join('\u{200B}');
}

extension _DateTimeExtension on DateTime {
  String hms([String separator = ':']) => '$hour$separator'
      '${'$minute'.padLeft(2, '0')}$separator'
      '${'$second'.padLeft(2, '0')}';
}
