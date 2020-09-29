import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/channel.dart';
import '../models/day_view.dart';

class TvGuideService {
  String _baseUrl; 

  TvGuideService()
    : _baseUrl = DotEnv().env['TV_GUIDE_API_URL'];

  Future<List<Channel>> getChannels() async {
    var response = await http.get('$_baseUrl/schedules/channels');
    return (jsonDecode(response.body)['channels'] as List).map((c) => Channel.fromJson(c)).toList();
  }

  Future<Channel> getChannelById(String id) async {
    var response = await http.get('$_baseUrl/schedules/channels/$id');
    return Channel.fromJson(jsonDecode(response.body)['channel']);
  }

  Future<List<DayView>> getTvGuideByDate(DateTime date) async {
    var response = await http.get('$_baseUrl/epg/dayviews/${_formatDate(date)}?ch=1'); // TODO use all channels
    return (jsonDecode(response.body) as List).map((e) => DayView.fromJson(e)).toList(); 
  }

  String _formatDate(DateTime date) => '${date.year}-${date.month}-${date.day}';
}