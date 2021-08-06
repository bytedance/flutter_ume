///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 4/13/21 1:58 PM
///
import 'package:dio/dio.dart';

import '../constants/constants.dart';
import '../instances.dart';

class UMEDioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[DIO_EXTRA_START_TIME] = DateTime.now();
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    response.requestOptions.extra[DIO_EXTRA_END_TIME] = DateTime.now();
    InspectorInstance.httpContainer.addRequest(response);
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    err.response ??= Response<dynamic>(requestOptions: err.requestOptions);
    err.response!.requestOptions.extra[DIO_EXTRA_END_TIME] = DateTime.now();
    InspectorInstance.httpContainer.addRequest(err.response!);
    handler.next(err);
  }
}
