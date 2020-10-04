import 'package:SportsGuide/dtos/tv_program_dto.dart';
import 'package:SportsGuide/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/tv_guide_service.dart';

class TvGuideNotifier with ChangeNotifier {
  final _tvGuideService = GetIt.I<ITvGuideService>();
  DateTime _selectedDate = DateTime.now();
  List<TvProgramDto> _programs = [];
  bool _showSports = false;

  TvGuideNotifier() {
    fetchAllSports();
  }

  DateTime get selectedDate => _selectedDate;
  Future<void> updateDate(DateTime date) async {
    _selectedDate = date;
    await fetchAllSports();
  }

  List<TvProgramDto> get programs => _programs;
  void setPrograms(List<TvProgramDto> programs) {
    _programs = programs;
    notifyListeners();
  }

  Future<void> fetchAllSports() async {
    final programs = await _fetchAllSportsByChosenDate();
    setPrograms(programs);
  }

  Future<List<TvProgramDto>> _fetchAllSportsByChosenDate() async {
    final dayviews = await _tvGuideService.getTvGuideByDate(_selectedDate);
    final programs = dayviews.map((channel) => channel.programs
        .where((program) => program.categories.contains('Sport'))
        .map((x) => TvProgramDto(x.categories, x.endTime, x.id, x.startTime,
            x.title, channel.channelId)));

    return programs.fold<List<TvProgramDto>>(
        [], (prev, elements) => [...prev, ...elements]).toList();
  }

  bool get showSports => _showSports;
  void updateShowSport(bool value) {
    _showSports = value;
    fetchChosenSports();
  }

  Future<void> fetchChosenSports() async {
    if (!_showSports) {
      await fetchAllSports();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final chosenSports = prefs.getStringList(Constants.PREFS_SPORTS) ?? [];
    if (chosenSports.isEmpty) {
      return;
    }

    final programs = await _fetchAllSportsByChosenDate();
    final filteredPrograms = chosenSports.map((sport) {
      return programs.where((program) {
        return program.title.toLowerCase().indexOf(sport.toLowerCase()) != -1;
      });
    });
    final allPrograms = filteredPrograms.fold<List<TvProgramDto>>(
        [], (prev, elements) => [...prev, ...elements]).toList();
    setPrograms(allPrograms);
  }
}
