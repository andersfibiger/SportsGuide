import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/constants.dart';

class SportsNotifier with ChangeNotifier {
  List<String> _sports = [];
  List<String> get sports => _sports;

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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(Constants.PREFS_SPORTS, _sports);
  }

  Future _fetchSports() async {
    final prefs = await SharedPreferences.getInstance();
    _sports = prefs.getStringList(Constants.PREFS_SPORTS) ?? [];
    notifyListeners();
  }
}
