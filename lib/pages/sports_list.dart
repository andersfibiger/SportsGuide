import 'package:SportsGuide/change_notifiers/sports_notifier.dart';
import 'package:SportsGuide/change_notifiers/tv_guide_notifier.dart';
import 'package:SportsGuide/common/button.dart';
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
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add sport to filter for', style: TextStyle(fontSize: 20)),
          SizedBox(height: 10.0),
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: context.watch<SportsNotifier>().sports.length,
              itemBuilder: (context, index) {
                final sport = context.read<SportsNotifier>().sports[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(sport),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async => await _onRemoveSport(context, sport),
                      ),
                    ),
                    Divider(),
                  ],
                );
              },
            ),
          ),
          Center(
            child: Button(
              onPressed: () async =>
                  await _onAddSport(context, _textController.text),
              child: Text('Add sport'),
              iconData: Icons.add_box,
            ),
          ),
        ],
      ),
    );
  }
}
