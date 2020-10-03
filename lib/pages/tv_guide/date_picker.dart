import 'package:SportsGuide/change_notifiers/channels_notifier.dart';
import 'package:SportsGuide/change_notifiers/tv_guide_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DatePicker extends StatelessWidget {
  const DatePicker();

  Future<void> _onSelectDate(BuildContext context) async {
    var pickedDate = await showDatePicker(
      context: context,
      initialDate: context.read<TvGuideNotifier>().selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 7)),
    );

    if (pickedDate != null &&
        pickedDate != context.read<TvGuideNotifier>().selectedDate) {
      context.read<TvGuideNotifier>().updateDate(pickedDate);
    }
  }

  String _getDate(DateTime date) => '${date.toLocal()}'.split(' ')[0];

  @override
  Widget build(BuildContext context) {
    print('building datepicker');
    return Container(
      child: TextField(
        readOnly: true,
        onTap: () async => await _onSelectDate(context),
        controller: TextEditingController(
          text: _getDate(context.watch<TvGuideNotifier>().selectedDate),
        ),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0)
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          icon: Icon(Icons.today, color: Theme.of(context).accentColor),
        ),
      ),
    );
  }
}
