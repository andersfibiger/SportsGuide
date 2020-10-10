import 'package:flutter/material.dart';
import 'channels_list.dart';
import 'sports_list.dart';
import 'tv_guide/tv_guide_list.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
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

  final _titles = <String>['Upcoming sports', 'Channels', 'Sports'];

  static final _widgets = <Widget>[TvGuideList(), ChannelsList(), SportsList()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles.elementAt(_currentIndex)),
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
          BottomNavigationBarItem(icon: Icon(Icons.sports), label: 'Sports')
        ],
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
