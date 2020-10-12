import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../change_notifiers/sports_notifier.dart';
import '../../change_notifiers/tv_guide_notifier.dart';
import '../../common/button.dart';
import '../../common/search_field_container.dart';
import 'sport_tile.dart';

class SportsList extends StatelessWidget {
  final _textController = TextEditingController();

  Future<void> _onAddSport(BuildContext context, String sport) async {
    if (sport.isEmpty) {
      _showSnackBar(context, 'Enter a sport to add');
      return;
    }

    if (context.read<SportsNotifier>().sports.contains(sport.toLowerCase())) {
      _showSnackBar(context, '$sport already exists');
      return;
    }

    context.read<SportsNotifier>().addSport(sport);
    _textController.clear();
    await context.read<TvGuideNotifier>().fetchSports();
  }

  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          Icon(Icons.warning_amber_sharp, color: Theme.of(context).accentColor),
          SizedBox(width: 10),
          Text(text)
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(milliseconds: 1500),
    ));
  }

  Future<void> _onRemoveSport(BuildContext context, String sport) async {
    context.read<SportsNotifier>().removeSport(sport);
    await context.read<TvGuideNotifier>().fetchSports();
  }

  String _capitalizeFirstLetter(String value) =>
      value[0].toUpperCase() + value.substring(1);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: const Text(
              'Add sport',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          SearchFieldContainer(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Sport',
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: context.watch<SportsNotifier>().sports.isEmpty
                ? Center(
                    child: Text(
                      'No sports added yet',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: context.watch<SportsNotifier>().sports.length,
                    itemBuilder: (context, index) {
                      final sport =
                          context.read<SportsNotifier>().sports[index];
                      return SportTile(
                        sport: _capitalizeFirstLetter(sport),
                        onDismissed: (direction) async =>
                            await _onRemoveSport(context, sport),
                      );
                    },
                  ),
          ),
          Center(
            child: Button(
              onPressed: () async =>
                  await _onAddSport(context, _textController.text),
              child: const Text('Add sport'),
              iconData: Icons.add,
            ),
          ),
        ],
      ),
    );
  }
}
