import 'package:SportsGuide/services/tv_guide_service.dart';
import 'package:SportsGuide/util/date_formatter.dart';
import 'package:get_it/get_it.dart';

void setupGetIt() {
  GetIt.I.registerFactory<ITvGuideService>(() => TvGuideService());
  GetIt.I.registerFactory<IDateFormatter>(() => DateFormatter());
}