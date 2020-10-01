import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Channels extends ChangeNotifier {
  List<String> _channelIds = [];
  List<String> get channelIds => _channelIds;

  Channels() {
    fetchFavourites();
  }

  void updateChannelsById(String id) {
    if (_channelIds.contains(id)) {
      _channelIds.remove(id);
    } else {
      _channelIds.add(id);
    }

    notifyListeners();
  }

  void clearChannelIds() {
    _channelIds.clear();
    notifyListeners();
  }

  Future saveFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('channels', _channelIds);
  }

  Future fetchFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    _channelIds = prefs.getStringList('channels') ?? [];
    notifyListeners();
  }
}
