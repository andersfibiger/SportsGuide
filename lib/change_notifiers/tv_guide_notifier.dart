import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../models/program.dart';
import '../services/tv_guide_service.dart';

class TvGuideNotifier with ChangeNotifier {
  final _tvGuideService = GetIt.I<ITvGuideService>();
  DateTime _selectedDate = DateTime.now();
  List<Program> _programs = [];

  TvGuideNotifier() {
    fetchSportsFromDate();
  }


  DateTime get selectedDate => _selectedDate;
  Future<void> updateDate(DateTime date) async  {
    _selectedDate = date;
    await fetchSportsFromDate();
  }

  List<Program> get programs => _programs;
  void setPrograms(List<Program> programs) {
    _programs = programs;
    notifyListeners();
  }

  Future<void> fetchSportsFromDate() async {
    var dayviews = await _tvGuideService.getTvGuideByDate(_selectedDate);
    var programs = dayviews.map((x) => x.programs.where((program) => program.categories.contains('Sport')));
    var allPrograms = programs.fold<List<Program>>([], (prev, elements) => [...prev, ...elements]).toList();
    setPrograms(allPrograms);
  }
  

}