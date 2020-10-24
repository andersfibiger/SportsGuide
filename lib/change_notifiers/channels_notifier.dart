import 'package:SportsGuide/services/preference_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../models/channel.dart';
import '../services/tv_guide_service.dart';
import '../util/constants.dart';

class ChannelsNotifier extends ChangeNotifier {
  List<Channel> _savedChannels = [];
  List<Channel> get savedChannels => _savedChannels;
  List<Channel> _channels = [];
  List<Channel> get channels => _channels;
  final preferenceService = GetIt.I<IPreferenceService>();

  ChannelsNotifier() {
    _getChannels();
    _fetchFavourites();
  }

  void updateSavedChannels(Channel channel) {
    if (_savedChannels.contains(channel)) {
      _savedChannels.remove(channel);
    } else {
      _savedChannels.add(channel);
    }

    notifyListeners();
  }

  void filterChannels(String query) async {
    final tvGuideService = GetIt.I<ITvGuideService>();
    _channels = await tvGuideService.getChannels();
    _channels.removeWhere((channel) =>
        channel.title.toLowerCase().indexOf(query.toLowerCase()) == -1);
    notifyListeners();
  }

  Future<void> _getChannels() async {
    final tvGuideService = GetIt.I<ITvGuideService>();
    _channels = await tvGuideService.getChannels();
    notifyListeners();
  }

  Future saveFavourites() async {
    final channelIds = _savedChannels.map((e) => e.id).toList();
    await preferenceService.setStrings(Constants.PREFS_CHANNELS, channelIds);
  }

  Future _fetchFavourites() async {
    final channelIds = (await preferenceService.getStrings(Constants.PREFS_CHANNELS)) ?? [];
    if (channelIds.isNotEmpty) {
      final tvGuideService = GetIt.I<ITvGuideService>();
      final mapped =
          channelIds.map((id) => tvGuideService.getChannelById(id)).toList();
      _savedChannels = await Future.wait(mapped);
    }

    notifyListeners();
  }
}
