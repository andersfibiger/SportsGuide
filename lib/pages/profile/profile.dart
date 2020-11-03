import 'package:SportsGuide/change_notifiers/settings_notifier.dart';
import 'package:SportsGuide/common/button.dart';
import 'package:SportsGuide/services/preference_service.dart';
import 'package:SportsGuide/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

class Profile extends StatelessWidget {
  final _preferenceService = GetIt.I<IPreferenceService>();

  Future<void> _showNumberDialog(BuildContext context) async {
    final pickedNumber = await showDialog<int>(
      context: context,
      builder: (context) => NumberPickerDialog.integer(
        minValue: 1,
        maxValue: 24,
        title: Text('How often should sports be checked in hours?'),
        initialIntegerValue: context.watch<SettingsNotifier>().notificationInterval ?? 1,
      ),
    );

    if (pickedNumber != null) {
      await context.read<SettingsNotifier>().updateInterval(pickedNumber);
      await _onSettingsChanged(context);
    }
  }

  Duration _getInitialDelay(BuildContext context) {
    final startTime = context.read<SettingsNotifier>().notificationStart;
    return Duration(hours: startTime.hour, minutes: startTime.minute);
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: context.read<SettingsNotifier>().notificationStart ?? TimeOfDay.now(),
      helpText: 'Pick when it should start from now',
    );

    if (selectedTime != null) {
      await context.read<SettingsNotifier>().updateStartTime(selectedTime);
      await _onSettingsChanged(context);
    }
  }

  Future<void> _onSettingsChanged(BuildContext context) async {
    final shouldSendNotifications = await _preferenceService.getBool(Constants.PREFS_SEND_NOTIFICATIONS);
    if (shouldSendNotifications != null && shouldSendNotifications) {
      await Workmanager.registerPeriodicTask(
        Constants.PERIODIC_TASK_NAME,
        Constants.PERIODIC_TASK,
        frequency: Duration(hours: context.read<SettingsNotifier>().notificationInterval),
        initialDelay: _getInitialDelay(context),
      );
    }
  }

  String _getIntervalText(BuildContext context) {
    final interval = context.watch<SettingsNotifier>().notificationInterval;
    switch (interval) {
      case 24:
        return 'Check for sports once a day';
      default:
        return 'Checks for sports every ${interval ?? 1} hour';
    }
  }

  String _getStartTimeText(BuildContext context) {
    final startTime = context.watch<SettingsNotifier>().notificationStart;
    if (startTime == null) {
      return 'Start in: ';
    }

    if (startTime.hour == 0 && startTime.minute < 15) {
      // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Minimum delay is 15 minutes. Setting to 15 minutes')));
      return 'Start in: 00:15 hours';
    }

    return 'Start in: ${startTime.format(context)} hours';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Text(
              _getIntervalText(context),
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            Text(
              _getStartTimeText(context),
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  child: Text(
                    'Change interval',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  onPressed: () async => await _showNumberDialog(context),
                  color: Theme.of(context).primaryColor,
                ),
                RaisedButton(
                  child: Text(
                    'Change when to start',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  onPressed: () async => await _showTimePicker(context),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
