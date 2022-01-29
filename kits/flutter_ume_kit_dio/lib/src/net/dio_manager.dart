import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

typedef RequestBodyBuilder = Map<String, dynamic> Function(String content);
const weiXin = 'https://qyapi.weixin.qq.com';
const dingTalk = 'https://oapi.dingtalk.com';
const feiShu = 'https://open.feishu.cn';

class DioManager {
  static DioManager? _instance;

  late Dio _dio;

  // whether use webhook or not
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

  // custom request body builder
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

  // send response to webhook
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

  // send custom message to webhook
  Future<void> sendCustomText(String content) async {
    if (!useBot) return;
    try {
      await _dio.post('', data: requestBodyBuilder!('not dio:\n $content'));
    } catch (error) {
      debugPrint('error on send response: $error');
    }
  }

  // build specific webhook request body
  void initRequestBodyBuilder(String url) {
    if (url.startsWith(dingTalk) || url.startsWith(weiXin)) {
      //dingTalk or wechat
      requestBodyBuilder = (content) => {
            "msgtype": "text",
            "text": {"content": content}
          };
      useBot = true;
    } else if (url.startsWith(feiShu)) {
      //feiShu
      requestBodyBuilder = (content) => {
            "msg_type": "text",
            "content": {"text": content}
          };
      useBot = true;
    }
  }
}
