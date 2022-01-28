///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/6 11:24
///
import 'dart:convert';

import 'package:dio/dio.dart' show Dio;
import 'package:flutter/material.dart';
import 'package:flutter_ume/core/pluggable.dart';

import 'models/http_interceptor.dart';
import 'net/dio_manager.dart';
import 'widgets/icon.dart' as icon;
import 'widgets/pluggable_state.dart';

// TODO(Alex): Implement [PluggableStream] for dot features.
/// Implement a [Pluggable] to integrate with UME.
class DioInspector extends StatefulWidget implements Pluggable {
  DioInspector({
    Key? key,
    required this.dio,
    String? webhookUrl,
    RequestBodyBuilder? requestBodyBuilder,
  }) : super(key: key) {
    dio.interceptors.add(UMEDioInterceptor());
    DioManager.instance.setWebhookUrl(webhookUrl);
    DioManager.instance.setRequestBodyBuilder(requestBodyBuilder);
  }

  final Dio dio;

  @override
  DioPluggableState createState() => DioPluggableState();

  @override
  ImageProvider<Object> get iconImageProvider =>
      MemoryImage(base64Decode(icon.iconData));

  @override
  String get name => 'DioInspector';

  @override
  String get displayName => 'DioInspector';

  @override
  void onTrigger() {}

  @override
  Widget buildWidget(BuildContext? context) => this;
}
