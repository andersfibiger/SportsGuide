import 'dart:convert';
import 'package:SportsGuide/services/preference_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../models/channel.dart';
import '../models/day_view.dart';
import '../util/constants.dart';

abstract class ITvGuideService {
  Future<List<Channel>> getChannels();
  Future<Channel> getChannelById(String id);
  Future<List<DayView>> getTvGuideByDate(DateTime date);
}

class TvGuideService implements ITvGuideService {
  String _baseUrl;
  final _preferenceService = GetIt.I<IPreferenceService>();

  TvGuideService() : _baseUrl = DotEnv().env['TV_GUIDE_API_URL'];

  Future<List<Channel>> getChannels() async {
    var response = await http.get('$_baseUrl/schedules/channels');
    return (jsonDecode(response.body)['channels'] as List)
        .map((c) => Channel.fromJson(c))
        .toList();
  }

  Future<Channel> getChannelById(String id) async {
    var response = await http.get('$_baseUrl/schedules/channels/$id');
    return Channel.fromJson(jsonDecode(response.body)['channel']);
  }

  Future<List<DayView>> getTvGuideByDate(DateTime date) async {
    if (date.isBefore(_getYesterDayDate())) {
      throw new Exception(
          'Cannot fetch tvguide since $date is before ${_getYesterDayDate()}');
    }

    var queryParams = await _getChannels();
    var query = '$_baseUrl/epg/dayviews/${_formatDate(date)}$queryParams';
    var response = await http.get(query);
    return (jsonDecode(response.body) as List)
        .map((e) => DayView.fromJson(e))
        .toList();
  }

  Future<String> _getChannels() async {
    final channelIds = await _preferenceService.getStrings(Constants.PREFS_CHANNELS);

    if (channelIds == null || channelIds.isEmpty) {
      return '?ch=1';
    }

    var query = channelIds.reduce((prev, curr) => '$prev&ch=$curr');
    query = '?ch=' + query;
    return query;
  }

  String _formatDate(DateTime date) => '${date.year}-${date.month}-${date.day}';

  DateTime _getYesterDayDate() {
    final yesterDay = DateTime.now().subtract(Duration(days: 1));
    return DateTime(yesterDay.year, yesterDay.month, yesterDay.day);
  }
}
