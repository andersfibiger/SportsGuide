import 'program_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../change_notifiers/tv_guide_notifier.dart';
import 'date_picker.dart';

class TvGuideList extends StatelessWidget {
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
                return ProgramTile(program: program);
              },
            ),
          ),
        ],
      ),
    );
  }
}
