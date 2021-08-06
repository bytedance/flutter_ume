///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 4/13/21 1:28 PM
///
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';

@immutable
class LogModel {
  const LogModel(
    this.message, {
    this.tag,
    this.stackTrace,
    this.isError = false,
  });

  final Object message;
  final String? tag;
  final StackTrace? stackTrace;
  final bool isError;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'message': message.toString(),
      'tag': tag,
      'stackTrace': stackTrace.toString(),
      'isError': isError,
    };
  }

  @override
  String toString() => const JsonEncoder.withIndent('  ').convert(toJson());

  @override
  int get hashCode => hashValues(message, tag, stackTrace, isError);

  @override
  bool operator ==(Object other) {
    return other is LogModel &&
        message == other.message &&
        tag == other.tag &&
        stackTrace == other.stackTrace &&
        isError == other.isError;
  }
}
