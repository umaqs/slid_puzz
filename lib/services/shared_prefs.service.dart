import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  const SharedPrefsService(this._prefs);

  final SharedPreferences _prefs;

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  Future<bool> setInt(String key, int value) {
    return _prefs.setInt(key, value);
  }
}
