import 'package:SportsGuide/controllers/tv_guide_controller.dart';
import 'package:SportsGuide/models/program.dart';
import 'package:flutter/material.dart';

class TvGuide extends StatelessWidget {
  const TvGuide();

  Future<List<Program>> _getTvGuide() async {
    await Future.delayed(Duration(seconds: 2));
    return await TvGuideController().getFootballMatchesToday();
  }

  String _parseMinute(int minute) => minute < 10 ? '0$minute' : '$minute';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      width: MediaQuery.of(context).size.width - 20,
      child: FutureBuilder<List<Program>>(
        future: _getTvGuide(),
        initialData: [],
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: Text('Loading...'));
            default:
              return Material(
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    final program = snapshot.data.elementAt(index);
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
