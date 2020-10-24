import 'package:SportsGuide/services/notification_service.dart';
import 'package:SportsGuide/util/constants.dart';
import 'package:SportsGuide/util/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'change_notifiers/channels_notifier.dart';
import 'change_notifiers/sports_notifier.dart';
import 'change_notifiers/tv_guide_notifier.dart';
import 'pages/home.dart';
import 'util/get_it.dart';

void callbackDispatcher() async {
  await DotEnv().load('.env');
  setupGetIt();

  Workmanager.executeTask((taskName, inputData) async {
    switch (taskName) {
      case Constants.PERIODIC_TASK:
        if (_isNotNight()) await Scheduler().checkForGames();
        break;
      default:
        break;
    }

    return Future.value(true);
  });
}

bool _isNotNight() {
  final currentTime = DateTime.now();
  return 11 <= currentTime.hour && currentTime.hour <= 21;
}

Future main() async {
  await DotEnv().load('.env');
  setupGetIt();
  await GetIt.I<INotificationService>().init();
  await Workmanager.initialize(callbackDispatcher);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChannelsNotifier()),
        ChangeNotifierProvider(create: (_) => TvGuideNotifier()),
        ChangeNotifierProvider(create: (_) => SportsNotifier()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sports guide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: ColorScheme(
          background: Color(0xFFe5e5e5),
          primary: Color(0xFF14213d),
          brightness: Brightness.light,
          error: Colors.red[900],
          onBackground: Colors.white,
          onError: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Color(0xFF829399),
          primaryVariant: Color(0xFF14313d),
          secondary: Color(0xFFfca311),
          secondaryVariant: Color(0xFFA44728),
          surface: Color(0xFFe5e5e5),
        ),
        textTheme: Typography.blackCupertino,
      ),
      home: Home(),
    );
  }
}
