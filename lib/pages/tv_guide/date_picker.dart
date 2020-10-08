import 'package:SportsGuide/change_notifiers/tv_guide_notifier.dart';
import 'package:SportsGuide/util/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class DatePicker extends StatelessWidget {
  final IDateFormatter _dateFormatter;

  DatePicker() : _dateFormatter = GetIt.I<IDateFormatter>();

  Future<void> _onSelectDate(BuildContext context) async {
    var pickedDate = await showDatePicker(
      context: context,
      initialDate: context.read<TvGuideNotifier>().selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );

    if (pickedDate != null &&
        pickedDate != context.read<TvGuideNotifier>().selectedDate) {
      context.read<TvGuideNotifier>().updateDate(pickedDate);
    }
  }

  String _getDate(DateTime date) {
    return _dateFormatter.getDay(date);
  }

  void _onNextDate(BuildContext context) {
    var currentDate = context.read<TvGuideNotifier>().selectedDate;
    context
        .read<TvGuideNotifier>()
        .updateDate(currentDate.add(Duration(days: 1)));
  }

  void _onPreviousDate(BuildContext context) {
    var currentDate = context.read<TvGuideNotifier>().selectedDate;
    context
        .read<TvGuideNotifier>()
        .updateDate(currentDate.subtract(Duration(days: 1)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => _onPreviousDate(context),
          ),
          Expanded(
            child: TextField(
              readOnly: true,
              onTap: () async => await _onSelectDate(context),
              controller: TextEditingController(
                text: _getDate(context.watch<TvGuideNotifier>().selectedDate),
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () => _onNextDate(context),
          ),
        ],
      ),
    );
  }
}

enum Direction { Right, Left }
