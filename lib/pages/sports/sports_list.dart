import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../change_notifiers/sports_notifier.dart';
import '../../change_notifiers/tv_guide_notifier.dart';
import '../../common/button.dart';
import '../../common/search_field_container.dart';
import 'sport_tile.dart';

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
                  border: InputBorder.none,
                  hintText: 'Sport',
                  helperText: ' ',
                ),
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
