import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'change_notifiers/channels_notifier.dart';
import 'change_notifiers/sports_notifier.dart';
import 'change_notifiers/tv_guide_notifier.dart';
import 'pages/home.dart';
import 'util/get_it.dart';

Future main() async {
  await DotEnv().load('.env');
  setupGetIt();
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
