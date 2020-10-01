import '../models/program.dart';
import '../services/tv_guide_service.dart';

abstract class ITvGuideController {
  Future<List<Program>> getFootballMatchesToday();
} 

class TvGuideController implements ITvGuideController {
  ITvGuideService _tvGuideService = TvGuideService();
  
  @override
  Future<List<Program>> getFootballMatchesToday() async {
    var dayviews = await _tvGuideService.getTvGuideByDate(DateTime.now());
    var programs = dayviews.map((x) => x.programs.where((program) => program.categories.contains('Sport')));
    var allPrograms = programs.fold<List<Program>>([], (prev, elements) => [...prev, ...elements]).toList();
    return allPrograms ?? List<Program>();
  }
  

}