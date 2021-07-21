import 'package:shared_preferences/shared_preferences.dart';

mixin StoreMixin {
  Future<SharedPreferences> _sharedPref = SharedPreferences.getInstance();

  /// Store a object with the [key]. The [obj] must be one of [bool], [double], [int], [String] or [List]<String>.
  Future<void> storeWithKey(String key, dynamic obj) async {
    if (obj == null) {
      return;
    }
    final savedKey = 'ume_${runtimeType.toString}_$key';
    final SharedPreferences prefs = await _sharedPref;
    if (obj is bool) {
      await prefs.setBool(savedKey, obj);
    } else if (obj is double) {
      await prefs.setDouble(savedKey, obj);
    } else if (obj is int) {
      await prefs.setInt(savedKey, obj);
    } else if (obj is String) {
      await prefs.setString(savedKey, obj);
    } else if (obj is List<String>) {
      await prefs.setStringList(savedKey, obj);
    }
  }

  /// Fetch a object by the [key]
  Future<dynamic> fetchWithKey(String key) async {
    final SharedPreferences prefs = await _sharedPref;
    final savedKey = 'ume_${runtimeType.toString}_$key';
    return await prefs.get(savedKey);
  }
}
