///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 4/13/21 2:49 PM
///
import 'package:flutter/widgets.dart';
import 'package:dio/dio.dart' show Response;

class HttpContainer extends ChangeNotifier {
  List<Response<dynamic>> get requests => _requests;
  final List<Response<dynamic>> _requests = <Response<dynamic>>[];

  int get page => _page;
  int _page = 1;

  void addRequest(Response<dynamic> response) {
    _requests.insert(0, response);
    notifyListeners();
  }

  void clearRequests() {
    _requests.clear();
    _page = 1;
    notifyListeners();
  }
}
