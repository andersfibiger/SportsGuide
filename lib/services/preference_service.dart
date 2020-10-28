import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IPreferenceService {
  Future<List<String>> getStrings(String key);
  Future<bool> setStrings(String key, List<String> values);
  Future<bool> getBool(String key);
  Future<bool> setBool(String key, bool value);
  Future<int> getInt(String key);
  Future<bool> setInt(String key, int value);
  Future<TimeOfDay> getTimeOfDay(String key);
  Future<void> setTimeOfDay(String key, TimeOfDay value);
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
  Future<bool> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }

  @override
  Future<bool> setStrings(String key, List<String> values) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(key, values);
  }

  @override
  Future<int> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  @override
  Future<bool> setInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt(key, value);
  }

  @override
  Future<TimeOfDay> getTimeOfDay(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final hour = await getInt('$key-hour');
    final minute = await getInt('$key-minute');

    if (hour == null && minute == null)
      return null;

    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  Future<void> setTimeOfDay(String key, TimeOfDay value) async {
    final prefs = await SharedPreferences.getInstance();

    await setInt('$key-hour', value.hour);
    await setInt('$key-minute', value.minute);
  }
}
