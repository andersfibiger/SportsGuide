import 'package:SportsGuide/change_notifiers/channels.dart';
import 'package:SportsGuide/change_notifiers/tv_guide_notifier.dart';
import 'package:SportsGuide/util/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'pages/home.dart';

Future main() async {
  await DotEnv().load('.env');
  setupGetIt();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Channels()),
        ChangeNotifierProvider(create: (_) => TvGuideNotifier()),
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}
