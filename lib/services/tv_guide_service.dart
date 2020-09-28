import 'dart:convert';
import 'dart:developer';
import 'package:SportsGuide/models/channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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

}