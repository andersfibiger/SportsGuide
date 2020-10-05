import 'package:SportsGuide/change_notifiers/sports_notifier.dart';
import 'package:SportsGuide/change_notifiers/tv_guide_notifier.dart';
import 'package:SportsGuide/common/button.dart';
import 'package:SportsGuide/common/search_field_container.dart';
import 'package:SportsGuide/common/sport_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SportsList extends StatelessWidget {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _onAddSport(BuildContext context, String sport) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    context.read<SportsNotifier>().addSport(sport);
    _formKey.currentState.reset();
    await context.read<TvGuideNotifier>().fetchSports();
  }

  Future<void> _onRemoveSport(BuildContext context, String sport) async {
    context.read<SportsNotifier>().removeSport(sport);
    await context.read<TvGuideNotifier>().fetchSports();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add sport to filter for',
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10.0),
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SearchFieldContainer(
              child: TextFormField(
                controller: _textController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter a sport';
                  }
                  if (context.read<SportsNotifier>().sports.contains(value)) {
                    return 'Already added';
                  }

                  return null;
                },
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Search'),
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: context.watch<SportsNotifier>().sports.length,
              itemBuilder: (context, index) {
                final sport = context.read<SportsNotifier>().sports[index];
                return SportTile(
                  sport: sport,
                  onDismissed: (direction) async => await _onRemoveSport(context, sport),
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
