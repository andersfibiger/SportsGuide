import 'package:SportsGuide/dtos/tv_program_dto.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../services/tv_guide_service.dart';

class TvGuideNotifier with ChangeNotifier {
  final _tvGuideService = GetIt.I<ITvGuideService>();
  DateTime _selectedDate = DateTime.now();
  List<TvProgramDto> _programs = [];

  TvGuideNotifier() {
    fetchSportsFromDate();
  }

  DateTime get selectedDate => _selectedDate;
  Future<void> updateDate(DateTime date) async  {
    _selectedDate = date;
    await fetchSportsFromDate();
  }

  List<TvProgramDto> get programs => _programs;
  void setPrograms(List<TvProgramDto> programs) {
    _programs = programs;
    notifyListeners();
  }

  Future<void> fetchSportsFromDate() async {
    var dayviews = await _tvGuideService.getTvGuideByDate(_selectedDate);
    var programs = dayviews.map((channel) {
      return channel.programs.where((program) => program.categories.contains('Sport'))
        .map((x) => TvProgramDto(x.categories, x.endTime, x.id, x.startTime, x.title, channel.channelId));
    });
    var allPrograms = programs.fold<List<TvProgramDto>>([], (prev, elements) => [...prev, ...elements]).toList();
    
    setPrograms(allPrograms);
  }
}