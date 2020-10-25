import 'package:SportsGuide/services/preference_service.dart';
import 'package:SportsGuide/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SettingsNotifier extends ChangeNotifier {
  int _notificationInterval;
  int get notificationInterval => _notificationInterval;
  final _preferenceService = GetIt.I<IPreferenceService>();

  SettingsNotifier() {
    _fetchInterval();
  }

  Future<void> _fetchInterval() async {
    final interval = (await _preferenceService.getInt(Constants.PREFS_NOTIFICATION_INTERVAL)) ?? 1;
    _notificationInterval = interval;
    notifyListeners();
  }

  Future<void> updateInterval(int interval) async {
    _notificationInterval = interval;
    await _preferenceService.setInt(Constants.PREFS_NOTIFICATION_INTERVAL, _notificationInterval);
    notifyListeners();
  }
}
