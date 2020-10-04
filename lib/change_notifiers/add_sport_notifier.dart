import 'package:flutter/material.dart';

class AddSportNotifier with ChangeNotifier {
  List<String> _sports = [];

  List<String> get sports => _sports;


  void removeSport(String sport) {
    _sports.remove(sport);
    notifyListeners();
  }

  void addSport(String sport) {
    _sports.add(sport);
    notifyListeners();
  }
}