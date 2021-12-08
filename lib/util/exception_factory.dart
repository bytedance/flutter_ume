import 'dart:convert';

class ExceptionFactory {
  static Exception get pluggableCommunicationNonexistKeyException =>
      Exception(json.encode({
        'error_code': 10001,
        'error_message': 'PluggableCommunicationNonexistKeyException',
        'ext_map': {}
      }));
  static Exception get pluggableCommunicationNotCommunicableException =>
      Exception(json.encode({
        'error_code': 10002,
        'error_message': 'pluggableCommunicationNotCommunicableException',
        'ext_map': {}
      }));
}
