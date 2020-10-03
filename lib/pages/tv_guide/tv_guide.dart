import 'package:SportsGuide/change_notifiers/tv_guide_notifier.dart';
import 'package:SportsGuide/models/program.dart';
import 'package:SportsGuide/pages/tv_guide/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TvGuide extends StatelessWidget {
  const TvGuide();

  String _parseMinute(int minute) => minute < 10 ? '0$minute' : '$minute';

  @override
  Widget build(BuildContext context) {
    print('building tvguide');
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      width: MediaQuery.of(context).size.width - 20,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DatePicker(),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: context.watch<TvGuideNotifier>().programs.length,
              itemBuilder: (context, index) {
                final program = context.read<TvGuideNotifier>().programs[index];
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
          ),
        ],
      ),
    );
  }
}
