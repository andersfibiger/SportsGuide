import 'package:flutter/material.dart';

class Channels extends ChangeNotifier {
  List<String> _channelIds = [];
  List<String> get channelIds => _channelIds;

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
}
