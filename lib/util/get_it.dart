import 'package:get_it/get_it.dart';
import '../services/tv_guide_service.dart';
import 'date_formatter.dart';

void setupGetIt() {
  GetIt.I.registerFactory<ITvGuideService>(() => TvGuideService());
  GetIt.I.registerFactory<IDateFormatter>(() => DateFormatter());
}