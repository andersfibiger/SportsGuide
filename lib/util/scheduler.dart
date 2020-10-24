import 'package:SportsGuide/dtos/tv_program_dto.dart';
import 'package:SportsGuide/services/notification_service.dart';
import 'package:SportsGuide/services/preference_service.dart';
import 'package:SportsGuide/services/tv_guide_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class Scheduler {
  final _tvguideService = GetIt.I<ITvGuideService>();
  final _notificationService = GetIt.I<INotificationService>();
  final _preferenceService = GetIt.I<IPreferenceService>();

  Future checkForGames() async {
    final chosenSports =
        (await _preferenceService.getStrings(Constants.PREFS_SPORTS)) ?? [];

    final dayviews = await _tvguideService.getTvGuideByDate(DateTime.now());
    final programs = dayviews.map((channel) => channel.programs
        .where((program) =>
            program.categories.contains('Sport') &&
            program.endTime.isAfter(DateTime.now()))
        .map((x) => TvProgramDto(x.categories, x.endTime, x.id, x.startTime,
            x.title, channel.channelId)));

    final allPrograms = programs.fold<List<TvProgramDto>>(
        [], (prev, elements) => [...prev, ...elements]);
    final sortedPrograms = allPrograms.where((program) => chosenSports.any(
        (sport) =>
            program.title.toLowerCase().indexOf(sport.toLowerCase()) != -1));

    if (sortedPrograms.isNotEmpty) {
      final upcommingPrograms = sortedPrograms.where((program) {
        final minutesToStart =
            program.startTime.difference(DateTime.now()).inMinutes;
        return 0 <= minutesToStart && minutesToStart <= 60;
      }).toList();

      if (upcommingPrograms.isNotEmpty) {
        upcommingPrograms.sort();
        final program = upcommingPrograms.first;
        final minutesBeforeStart =
            program.startTime.difference(DateTime.now()).inMinutes;
        await _notificationService.send(
            program.title, 'Starts in $minutesBeforeStart minutes');
      }
    }
  }
}