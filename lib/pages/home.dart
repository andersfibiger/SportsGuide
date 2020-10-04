import 'package:SportsGuide/pages/sports_list.dart';
import 'package:SportsGuide/pages/channels_list.dart';
import 'package:SportsGuide/pages/tv_guide/tv_guide_list.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  void _onTap(index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final _titles = <String>[
    'Upcoming sports',
    'Channels',
    'Sports'
  ];

  static final _widgets = <Widget>[
    TvGuideList(),
    ChannelsList(),
    SportsList()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles.elementAt(_currentIndex)),
      ),
      body: _widgets.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
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
            label: 'Sports'
          )
        ],
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
