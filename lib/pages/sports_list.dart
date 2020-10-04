import 'package:SportsGuide/change_notifiers/sports_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SportsList extends StatelessWidget {
  final _textController = TextEditingController();

  void _addSport(BuildContext context, String sport) {
    if (sport.isEmpty) {
      return;
    }

    context.read<SportsNotifier>().addSport(sport);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add sport to filter for', style: TextStyle(fontSize: 20)),
          SizedBox(height: 10.0),
          TextField(
            controller: _textController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: context.watch<SportsNotifier>().sports.length,
              itemBuilder: (context, index) {
                final sport = context.read<SportsNotifier>().sports[index];
                return ListTile(
                  title: Text(sport),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () =>
                        context.read<SportsNotifier>().removeSport(sport),
                  ),
                );
              },
            ),
          ),
          Center(
            child: RaisedButton(
              onPressed: () => _addSport(context, _textController.text),
              child: Text('Add sport'),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              color: Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
