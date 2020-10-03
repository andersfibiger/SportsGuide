import 'package:SportsGuide/services/tv_guide_service.dart';
import 'package:get_it/get_it.dart';

void setupGetIt() {
  GetIt.I.registerFactory<ITvGuideService>(() => TvGuideService());
}