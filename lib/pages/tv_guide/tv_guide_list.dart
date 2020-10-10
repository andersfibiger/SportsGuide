import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import '../../change_notifiers/tv_guide_notifier.dart';
import '../../dtos/tv_program_dto.dart';
import 'date_picker.dart';

class TvGuideList extends StatelessWidget {
  final String _logoBaseUrl = DotEnv().env['CHANNEL_LOGO_URL'];

  String _parseMinute(int minute) => minute < 10 ? '0$minute' : '$minute';

  String _getProgramTime(TvProgramDto program) =>
      '${program.startTime.hour}.${_parseMinute(program.startTime.minute)} - ${program.endTime.hour}.${_parseMinute(program.endTime.minute)}';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      width: MediaQuery.of(context).size.width - 20,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DatePicker(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Show only my sports'),
                    Checkbox(
                        value: context.watch<TvGuideNotifier>().showSports,
                        onChanged:
                            context.watch<TvGuideNotifier>().updateShowSport),
                  ],
                )
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: context.watch<TvGuideNotifier>().programs.length,
              itemBuilder: (context, index) {
                final program = context.read<TvGuideNotifier>().programs[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(program.title),
                      subtitle: Text(_getProgramTime(program)),
                      leading: Image.network(
                        '$_logoBaseUrl/${program.channelId}.png',
                        height: 100,
                        width: 50,
                      ),
                    ),
                    Divider()
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
