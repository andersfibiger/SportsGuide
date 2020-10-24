import 'package:SportsGuide/services/preference_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../util/constants.dart';

class SportsNotifier with ChangeNotifier {
  List<String> _sports = [];
  List<String> get sports => _sports;
  final preferenceService = GetIt.I<IPreferenceService>();

  SportsNotifier() {
    _fetchSports();
  }

  void removeSport(String sport) async {
    if (!_sports.remove(sport)) {
      return;
    }

    await saveSports();
    notifyListeners();
  }

  void addSport(String sport) async {
    sport = sport.toLowerCase().trim();
    if (_sports.contains(sport)) {
      return;
    }
    _sports.add(sport);
    await saveSports();
    notifyListeners();
  }

  Future saveSports() async {
    await preferenceService.setStrings(Constants.PREFS_SPORTS, _sports);
  }

  Future _fetchSports() async {
    _sports =
        (await preferenceService.getStrings(Constants.PREFS_SPORTS)) ?? [];
    notifyListeners();
  }
}
