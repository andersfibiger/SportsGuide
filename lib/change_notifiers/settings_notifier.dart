import 'package:SportsGuide/services/preference_service.dart';
import 'package:SportsGuide/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SettingsNotifier extends ChangeNotifier {
  final _preferenceService = GetIt.I<IPreferenceService>();

  int _notificationInterval;
  int get notificationInterval => _notificationInterval;
  TimeOfDay _notificationStartTime;
  TimeOfDay get notificationStart => _notificationStartTime;

  SettingsNotifier() {
    _fetchInterval();
    _fetchStartTime();
    notifyListeners();
  }

  Future<void> _fetchInterval() async {
    final interval = (await _preferenceService.getInt(Constants.PREFS_NOTIFICATION_INTERVAL)) ?? 1;
    _notificationInterval = interval;
  }

  Future<void> _fetchStartTime() async {
    final startTime =
        (await _preferenceService.getTimeOfDay(Constants.PREFS_INTERVAL_START)) ?? TimeOfDay.now();
    _notificationStartTime = startTime;
  }

  Future<void> updateInterval(int interval) async {
    _notificationInterval = interval;
    await _preferenceService.setInt(Constants.PREFS_NOTIFICATION_INTERVAL, _notificationInterval);
    notifyListeners();
  }

  Future<void> updateStartTime(TimeOfDay time) async {
    _notificationStartTime = time;
    await _preferenceService.setTimeOfDay(Constants.PREFS_INTERVAL_START, _notificationStartTime);
    notifyListeners();
  }
}
