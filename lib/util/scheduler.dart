import 'package:SportsGuide/dtos/tv_program_dto.dart';
import 'package:SportsGuide/services/notification_service.dart';
import 'package:SportsGuide/services/preference_service.dart';
import 'package:SportsGuide/services/tv_guide_service.dart';
import 'package:get_it/get_it.dart';
import 'constants.dart';

class Scheduler {
  final _tvguideService = GetIt.I<ITvGuideService>();
  final _notificationService = GetIt.I<INotificationService>();
  final _preferenceService = GetIt.I<IPreferenceService>();

  Future checkForGames() async {
    final programs = await getPrograms();
    final relevantPrograms = await getRelevantPrograms(programs);
    final programsWithInNextHour = await getProgramsWithInNextHour(relevantPrograms);

    if (programsWithInNextHour.isEmpty) {
      return;
    }

    programsWithInNextHour.sort();
    final program = programsWithInNextHour.first;
    final minutesBeforeStart = program.startTime.difference(DateTime.now()).inMinutes;
    if (programsWithInNextHour.length > 1) {
      await _notificationService.send(program.title,
          'Starts in $minutesBeforeStart minutes and ${programsWithInNextHour.length - 1} other program(s) within next hour');
    } else {
      await _notificationService.send(program.title, 'Starts in $minutesBeforeStart minutes');
    }
  }

  Future<List<TvProgramDto>> getPrograms() async {
    final dayviews = await _tvguideService.getTvGuideByDate(DateTime.now());
    final programs = dayviews.map((channel) => channel.programs
        .where((program) => program.categories.contains('Sport') && program.endTime.isAfter(DateTime.now()))
        .map((x) => TvProgramDto(x.categories, x.endTime, x.id, x.startTime, x.title, channel.channelId)));

    return programs.fold<List<TvProgramDto>>([], (prev, elements) => [...prev, ...elements]);
  }

  Future<List<TvProgramDto>> getRelevantPrograms(List<TvProgramDto> programs) async {
    final chosenSports = (await _preferenceService.getStrings(Constants.PREFS_SPORTS)) ?? [];

    return programs
        .where((program) =>
            chosenSports.any((sport) => program.title.toLowerCase().indexOf(sport.toLowerCase()) != -1))
        .toList();
  }

  Future<List<TvProgramDto>> getProgramsWithInNextHour(List<TvProgramDto> programs) async {
    if (programs.isNotEmpty) {
      return programs.where((program) {
        final minutesToStart = program.startTime.difference(DateTime.now()).inMinutes;
        return 0 <= minutesToStart && minutesToStart <= 60;
      }).toList();
    }

    return [];
  }
}
