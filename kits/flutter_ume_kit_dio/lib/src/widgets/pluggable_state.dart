///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/6 11:25
///
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../constants/extensions.dart';
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

class DioPluggableState extends State<DioInspector> {
  @override
  void initState() {
    super.initState();
    // Bind listener to refresh requests.
    InspectorInstance.httpContainer.addListener(_listener);
  }

  @override
  void dispose() {
    InspectorInstance.httpContainer
      ..removeListener(_listener) // First, remove refresh listener.
      ..resetPaging(); // Then reset the paging field.
    super.dispose();
  }

  /// Using [setState] won't cause too much performance regression,
  /// since we've implemented the list with `findChildIndexCallback`.
  void _listener() {
    Future.microtask(() {
      if (mounted &&
          !context.debugDoingBuild &&
          context.owner?.debugBuilding != true) {
        setState(() {});
      }
    });
  }

  Widget _clearAllButton(BuildContext context) {
    return TextButton(
      onPressed: InspectorInstance.httpContainer.clearRequests,
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
          Text('Clear'),
          Icon(Icons.cleaning_services, size: 14),
        ],
      ),
    );
  }

  Widget _itemList(BuildContext context) {
    final List<Response<dynamic>> requests =
        InspectorInstance.httpContainer.pagedRequests;
    final int length = requests.length;
    if (length > 0) {
      return CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, int index) {
                final Response<dynamic> r = requests[index];
                if (index == length - 2) {
                  InspectorInstance.httpContainer.loadNextPage();
                }
                return _ResponseCard(
                  key: ValueKey<int>(r.startTimeMilliseconds),
                  response: r,
                );
              },
              childCount: length,
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
                        'Dio Requests',
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

  Response<dynamic> get _response => widget.response;

  RequestOptions get _request => _response.requestOptions;

  /// The start time for the [_request].
  DateTime get _startTime => _response.startTime;

  /// The end time for the [_response].
  DateTime get _endTime => _response.endTime;

  /// The duration between the request and the response.
  Duration get _duration => _endTime.difference(_startTime);

  /// Status code for the [_response].
  int get _statusCode => _response.statusCode ?? 0;

  /// Colors matching status.
  Color get _statusColor {
    if (_statusCode >= 200 && _statusCode < 300) {
      return Colors.lightGreen;
    }
    if (_statusCode >= 300 && _statusCode < 400) {
      return Colors.orangeAccent;
    }
    if (_statusCode >= 400 && _statusCode < 500) {
      return Colors.purple;
    }
    if (_statusCode >= 500 && _statusCode < 600) {
      return Colors.red;
    }
    return Colors.blueAccent;
  }

  /// The method that the [_request] used.
  String get _method => _request.method;

  /// The [Uri] that the [_request] requested.
  Uri get _requestUri => _request.uri;

  String? get _requestHeadersBuilder {
    final Map<String, List<String>> map = _request.headers.map(
      (key, value) => MapEntry(
        key,
        value is Iterable ? value.map((v) => v.toString()).toList() : [value.toString()],
      ),
    );
    final Headers headers = Headers.fromMap(map);
    if (headers.isEmpty) {
      return null;
    }
    return '$headers';
  }

  /// Data for the [_request].
  String? get _requestDataBuilder {
    if (_request.data is Map) {
      return _encoder.convert(_request.data);
    }
    return _request.data?.toString();
  }

  /// Data for the [_response].
  String? get _responseDataBuilder {
    final data = _response.data;
    if (data == null) {
      return null;
    }
    if (_response.data is Map) {
      return _encoder.convert(_response.data);
    }
    return _response.data.toString();
  }

  String? get _responseHeadersBuilder {
    if (_response.headers.isEmpty) {
      return null;
    }
    return '${_response.headers}';
  }

  Widget _detailButton(BuildContext context) {
    return TextButton(
      onPressed: _switchExpand,
      style: _buttonStyle(context),
      child: const Text(
        'Detail🔍',
        style: TextStyle(fontSize: 12, height: 1.2),
      ),
    );
  }

  Widget _infoContent(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(_startTime.hms()),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 1,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: _statusColor,
          ),
          child: Text(
            _statusCode.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          _method,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 6),
        Text('${_duration.inMilliseconds}ms'),
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
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _TagText(
                tag: 'Request headers',
                content: _requestHeadersBuilder,
              ),
              _TagText(
                tag: 'Request data',
                content: _requestDataBuilder,
              ),
              _TagText(
                tag: 'Response body',
                content: _responseDataBuilder,
              ),
              _TagText(
                tag: 'Response headers',
                content: _responseHeadersBuilder,
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
            _TagText(
              tag: 'Uri',
              content: '$_requestUri',
              shouldStartFromNewLine: false,
            ),
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
    this.content,
    this.shouldStartFromNewLine = true,
  }) : super(key: key);

  final String tag;
  final String? content;
  final bool shouldStartFromNewLine;

  TextSpan get span {
    return TextSpan(
      children: <TextSpan>[
        TextSpan(
          text: '$tag: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        if (shouldStartFromNewLine) TextSpan(text: '\n'),
        TextSpan(text: content!),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (content == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SelectableText.rich(span),
    );
  }
}

extension _DateTimeExtension on DateTime {
  String hms([String separator = ':']) => '$hour$separator'
      '${'$minute'.padLeft(2, '0')}$separator'
      '${'$second'.padLeft(2, '0')}';
}
