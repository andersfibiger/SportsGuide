import 'package:SportsGuide/services/notification_service.dart';
import 'package:SportsGuide/services/preference_service.dart';
import 'package:get_it/get_it.dart';
import '../services/tv_guide_service.dart';
import 'date_formatter.dart';

void setupGetIt() {
  GetIt.I.registerFactory<ITvGuideService>(() => TvGuideService());
  GetIt.I.registerFactory<IDateFormatter>(() => DateFormatter());
  GetIt.I.registerFactory<INotificationService>(() => NotificationService());
  GetIt.I.registerFactory<IPreferenceService>(() => PreferenceService());
}