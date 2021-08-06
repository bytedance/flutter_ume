///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 4/13/21 2:49 PM
///
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:dio/dio.dart' show Response;

/// Implements a [ChangeNotifier] to notify listeners when new responses
/// were recorded. Use [page] to support paging.
class HttpContainer extends ChangeNotifier {
  /// Store all responses.
  List<Response<dynamic>> get requests => _requests;
  final List<Response<dynamic>> _requests = <Response<dynamic>>[];

  /// Paging fields.
  int get page => _page;
  int _page = 1;
  final int _perPage = 10;

  /// Return requests according to the paging.
  List<Response<dynamic>> get pagedRequests {
    return _requests.sublist(0, math.min(page * _perPage, _requests.length));
  }

  bool get _hasNextPage => _page * _perPage < _requests.length;

  void addRequest(Response<dynamic> response) {
    _requests.insert(0, response);
    notifyListeners();
  }

  void loadNextPage() {
    if (!_hasNextPage) {
      return;
    }
    _page++;
    notifyListeners();
  }

  void resetPaging() {
    _page = 1;
    notifyListeners();
  }

  void clearRequests() {
    _requests.clear();
    _page = 1;
    notifyListeners();
  }

  @override
  void dispose() {
    _requests.clear();
    super.dispose();
  }
}
