import 'package:SportsGuide/models/day_view.dart';
import 'package:SportsGuide/services/tv_guide_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'controllers/tv_guide_controller.dart';
import 'models/program.dart';

Future main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
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
      home: TvGuide(),
    );
  }
}

class TvGuide extends StatelessWidget {
  Future<List<Program>> _getTvGuide() async {
    await Future.delayed(Duration(seconds: 2));
    return await TvGuideController().getFootballMatchesToday();
  }

  String _parseMinute(int minute) => minute < 10 ? '0$minute' : '$minute';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      color: Colors.blue,
      child: FutureBuilder<List<Program>>(
        future: _getTvGuide(),
        initialData: [],
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              return Material(
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    final program =
                        snapshot.data.elementAt(index);
                    return Column(
                      children: [
                        Text(program.title),
                        SizedBox(height: 10),
                        Text(
                            '${program.startTime.hour}.${_parseMinute(program.startTime.minute)} - ${program.endTime.hour}.${_parseMinute(program.endTime.minute)}'),
                      ],
                    );
                  },
                ),
              );
          }
        },
      ),
    );
  }
}
