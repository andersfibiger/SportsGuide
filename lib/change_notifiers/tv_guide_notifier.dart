import 'dart:async';
import 'package:SportsGuide/services/preference_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../dtos/tv_program_dto.dart';
import '../services/tv_guide_service.dart';
import '../util/constants.dart';

class TvGuideNotifier with ChangeNotifier {
  final _tvGuideService = GetIt.I<ITvGuideService>();
  final _preferenceService = GetIt.I<IPreferenceService>();
  DateTime _selectedDate = DateTime.now();
  int previousPage = 1;
  List<TvProgramDto> _programs = [];
  bool didPickDate = false;
  bool _showSports = false;


  TvGuideNotifier() {
    fetchSports();
  }

  DateTime get selectedDate => _selectedDate;
  Future<void> updateDate(DateTime date) async {
    _selectedDate = date;
    await fetchSports();
  }

  List<TvProgramDto> get programs => _programs;
  void sortAndSetPrograms(List<TvProgramDto> programs) {
    _programs = programs;
    _programs.sort();
    notifyListeners();
  }

  Future<void> fetchAllSports() async {
    final programs = await _fetchAllSportsByChosenDate();
    sortAndSetPrograms(programs);
  }

  Future<List<TvProgramDto>> _fetchAllSportsByChosenDate() async {
    final dayviews = await _tvGuideService.getTvGuideByDate(_selectedDate);
    final programs = dayviews.map((channel) => channel.programs
        .where((program) => program.categories.contains('Sport')
        && program.endTime.isAfter(DateTime.now()))
        .map((x) => TvProgramDto(x.categories, x.endTime, x.id, x.startTime,
            x.title, channel.channelId)));

    return programs.fold<List<TvProgramDto>>(
        [], (prev, elements) => [...prev, ...elements]).toList();
  }

  bool get showSports => _showSports;
  void updateShowSport(bool value) {
    _showSports = value;
    fetchSports();
  }

  Future<void> fetchSports() async {
    if (!_showSports) {
      await fetchAllSports();
      return;
    }

    final chosenSports = (await _preferenceService.getStrings(Constants.PREFS_SPORTS)) ?? [];
    if (chosenSports.isEmpty) {
      notifyListeners();
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
    sortAndSetPrograms(allPrograms);
  }
}
