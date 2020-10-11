import 'package:SportsGuide/dtos/tv_program_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProgramTile extends StatelessWidget {
  ProgramTile({
    Key key,
    @required this.program,
  })  : _logoBaseUrl = DotEnv().env['CHANNEL_LOGO_URL'],
        super(key: key);

  final TvProgramDto program;
  final String _logoBaseUrl;

  String _parseMinute(int minute) => minute < 10 ? '0$minute' : '$minute';

  String _getProgramTime(TvProgramDto program) =>
      '${program.startTime.hour}.${_parseMinute(program.startTime.minute)} - ${program.endTime.hour}.${_parseMinute(program.endTime.minute)}';

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTile(
        title: Text(program.title),
        subtitle: Text(_getProgramTime(program)),
        leading: Image.network(
          '$_logoBaseUrl/${program.channelId}.png',
          height: 100,
          width: 50,
        ),
      ),
    );
  }
}
