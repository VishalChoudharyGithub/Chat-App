import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  SharedPreferences _prefs;

  Future _getPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<String> getLoggedInEmail() async {
    await _getPrefs();
    return _prefs.getString("email") ?? null;
  }

  Future<String> getLoggedInUser() async {
    await _getPrefs();
    return _prefs.getString("token") ?? null;
  }

  Future<bool> clear() async {
    await _getPrefs();
    return _prefs.clear();
  }
}
