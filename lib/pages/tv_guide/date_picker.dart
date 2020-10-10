import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../../change_notifiers/tv_guide_notifier.dart';
import '../../util/date_formatter.dart';

class DatePicker extends StatelessWidget {
  final IDateFormatter _dateFormatter;
  final _pageController = PageController(initialPage: 1);

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

  void _onDateChanged(BuildContext context, int page) {
    if (page < context.read<TvGuideNotifier>().previousPage) {
      _onPreviousDate(context);
    } else {
      _onNextDate(context);
    }

    context.read<TvGuideNotifier>().previousPage = page;
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
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              child: PageView.builder(
                onPageChanged: (page) => _onDateChanged(context, page),
                controller: _pageController,
                itemBuilder: (context, index) {
                  return TextField(
                    readOnly: true,
                    onTap: () async => await _onSelectDate(context),
                    controller: TextEditingController(
                      text: _getDate(
                          context.read<TvGuideNotifier>().selectedDate),
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
                  );
                },
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
