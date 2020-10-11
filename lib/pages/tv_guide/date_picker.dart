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
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );

    if (pickedDate != null &&
        pickedDate != context.read<TvGuideNotifier>().selectedDate) {
      context.read<TvGuideNotifier>().didPickDate = true;
      await context.read<TvGuideNotifier>().updateDate(pickedDate);

      final page = _calculatePageNumber(pickedDate);
      _pageController.jumpToPage(page);
    }
  }

  int _calculatePageNumber(DateTime pickedDate) {
    var currentDate = DateTime.now();
    currentDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day);

    final difference = pickedDate.difference(currentDate);
    return difference.inDays + 1;
  }

  String _getDate(BuildContext context, int index) {
    final currentDate = DateTime.now();
    DateTime newDate;
    switch (index) {
      case 0:
        newDate = currentDate.subtract(Duration(days: 1));
        break;
      case 1:
        newDate = currentDate;
        break;
      default:
        newDate = currentDate.add(Duration(days: index - 1));
        break;
    }

    return _dateFormatter.getDay(newDate);
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
    if (context.read<TvGuideNotifier>().didPickDate) {
      context.read<TvGuideNotifier>().previousPage = page;
      context.read<TvGuideNotifier>().didPickDate = false;
      return;
    }

    if (page == context.read<TvGuideNotifier>().previousPage - 1) {
      _onPreviousDate(context);
    } else if (page == context.read<TvGuideNotifier>().previousPage + 1) {
      _onNextDate(context);
    } else {
      return;
    }

    context.read<TvGuideNotifier>().previousPage = page;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Icon(Icons.arrow_back_ios),
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
                      text: _getDate(context, index),
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
          Icon(Icons.arrow_forward_ios)
        ],
      ),
    );
  }
}
