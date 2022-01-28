import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

typedef RequestBodyBuilder = Map<String, dynamic> Function(String content);
const weiXin = 'https://qyapi.weixin.qq.com';
const dingTalk = 'https://oapi.dingtalk.com';
const feiShu = 'https://open.feishu.cn';

class DioManager {
  static DioManager? _instance;

  late Dio _dio;
  bool useBot = false;

  RequestBodyBuilder? requestBodyBuilder;

  DioManager._internal() {
    var options = BaseOptions(
      connectTimeout: 15000,
      receiveTimeout: 15000,
      headers: {'Content-Type': Headers.jsonContentType},
    );
    _dio = Dio(options);
  }

  static DioManager get instance => _instance ??= DioManager._internal();

  void setRequestBodyBuilder(RequestBodyBuilder? builder) {
    if (builder == null) return;
    requestBodyBuilder = builder;
    useBot = true;
  }

  void setWebhookUrl(String? url) {
    if (url == null) return;
    _dio.options.baseUrl = url;
    initRequestBodyBuilder(url);
  }

  Future<bool> sendResponse({
    required String uri,
    required String requestData,
    required String responseBody,
    required String requestHeader,
    required String duration,
    required String statusCode,
    required String method,
  }) async {
    try {
      var content =
          "agent: dio\n$statusCode $method duration: $duration\n$uri\n\nrequest data: "
          "\n$requestData\n"
          "\nresponse body: \n$responseBody\n\nrequest header\n$requestHeader";
      await _dio.post('', data: requestBodyBuilder!(content));
      return true;
    } catch (error) {
      debugPrint('error on send response: $error');
      return false;
    }
  }

  Future<void> sendCustomText(String content) async {
    try {
      await _dio.post('', data: requestBodyBuilder!('not dio:\n $content'));
    } catch (error) {
      debugPrint('error on send response: $error');
    }
  }

  void initRequestBodyBuilder(String url) {
    if (url.startsWith(dingTalk) || url.startsWith(weiXin)) {
      //钉钉或微信机器人
      requestBodyBuilder = (content) => {
            "msgtype": "text",
            "text": {"content": content}
          };
      useBot = true;
    } else if (url.startsWith(feiShu)) {
      //飞书机器人
      requestBodyBuilder = (content) => {
            "msg_type": "text",
            "content": {"text": content}
          };
      useBot = true;
    }
  }
}
