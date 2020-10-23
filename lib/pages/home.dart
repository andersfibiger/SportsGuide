import 'package:SportsGuide/util/constants.dart';
import 'package:SportsGuide/util/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'channels/channels_list.dart';
import 'sports/sports_list.dart';
import 'tv_guide/tv_guide_list.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  bool _sendNotifications = false;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _initPreferences();
  }

  Future<void> _initPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _sendNotifications = prefs.getBool(Constants.PREFS_SEND_NOTIFICATIONS);
    });
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  void _onTap(index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  Future _onNotificationChange() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _sendNotifications = !_sendNotifications;
    });

    await prefs.setBool(Constants.PREFS_SEND_NOTIFICATIONS, _sendNotifications);

    if (_sendNotifications) {
      await Workmanager.registerPeriodicTask(
        Constants.PERIODIC_TASK_NAME,
        Scheduler.periodicTask,
        frequency: Duration(hours: 12)
      );

      // await Workmanager.registerOneOffTask('asdasdsd', Scheduler.periodicTask);
    } else {
      await Workmanager.cancelByUniqueName(Constants.PERIODIC_TASK_NAME);
    }
  }

  final _titles = <String>['Upcoming sports', 'Channels', 'Sports'];

  static final _widgets = <Widget>[TvGuideList(), ChannelsList(), SportsList()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles.elementAt(_currentIndex)),
        actions: [
          IconButton(
              icon: Icon(
                _sendNotifications
                    ? Icons.notifications_on
                    : Icons.notifications_off,
              ),
              onPressed: _onNotificationChange),
        ],
      ),
      body: PageView(
        children: _widgets,
        controller: _pageController,
        onPageChanged: _onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Programs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Channels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports),
            label: 'Sports',
          )
        ],
        currentIndex: _currentIndex,
        onTap: _onTap,
        selectedItemColor: Theme.of(context).accentColor,
        unselectedItemColor: Theme.of(context).colorScheme.onBackground,
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
