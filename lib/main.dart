import 'package:SportsGuide/controllers/channel_controller.dart';
import 'package:SportsGuide/get_it.dart';
import 'package:SportsGuide/services/channel_favourites.dart';
import 'package:SportsGuide/tv_guide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future main() async {
  await DotEnv().load('.env');
  setupGetIt();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Channels()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: TvGuide(),
      home: Material(child: ChannelFavourites()),
    );
  }
}
