import 'package:shared_preferences/shared_preferences.dart';

abstract class IPreferenceService {
  Future<List<String>> getStrings(String key);
  Future<void> setStrings(String key, List<String> values);
  Future<bool> getBool(String key);
  Future<void> setBool(String key, bool value);
}

class PreferenceService implements IPreferenceService {
  @override
  Future<List<String>> getStrings(String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(key);
  }

  @override
  Future<bool> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }

  @override
  Future<void> setStrings(String key, List<String> values) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(key, values);
  }
}
