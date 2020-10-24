import 'package:SportsGuide/services/preference_service.dart';
import 'package:SportsGuide/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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
  final _preferenceService = GetIt.I<IPreferenceService>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _initPreferences();
  }

  Future<void> _initPreferences() async {
    final value = await _preferenceService.getBool(Constants.PREFS_SEND_NOTIFICATIONS);
    setState(() {
      _sendNotifications = value;
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
    setState(() {
      _sendNotifications = !_sendNotifications;
    });

    await _preferenceService.setBool(Constants.PREFS_SEND_NOTIFICATIONS, _sendNotifications);

    if (_sendNotifications) {
      await Workmanager.registerPeriodicTask(
        Constants.PERIODIC_TASK_NAME,
        Constants.PERIODIC_TASK,
        frequency: Duration(hours: 1),
        initialDelay: Duration(hours: 1),
      );
    } else {
      await Workmanager.cancelByUniqueName(Constants.PERIODIC_TASK_NAME);
    }
  }

  static final _titles = <String>['Upcoming sports', 'Channels', 'Sports'];
  static final _widgets = <Widget>[TvGuideList(), ChannelsList(), SportsList()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles.elementAt(_currentIndex)),
        actions: [
          IconButton(
            icon: Icon(
              _sendNotifications ? Icons.notifications_on : Icons.notifications_off,
              color: Theme.of(context).accentColor,
            ),
            onPressed: _onNotificationChange,
            tooltip: 'Check for upcomming games every hour',
          ),
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
