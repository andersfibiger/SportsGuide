import 'dart:ui';
import 'package:SportsGuide/change_notifiers/channels_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChannelFavourites extends StatelessWidget {
  const ChannelFavourites();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) =>
                  context.read<ChannelsNotifier>().filterChannels(query),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                prefixIcon:
                    Icon(Icons.search, color: Theme.of(context).accentColor),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: context.watch<ChannelsNotifier>().channels.length,
              itemBuilder: (context, index) {
                final channel = context.read<ChannelsNotifier>().channels[index];
                return CheckboxListTile(
                  title: Text(channel.title),
                  secondary: Image.network(
                    channel.logo,
                    height: 40,
                    width: 40,
                  ),
                  onChanged: (_) =>
                      context.read<ChannelsNotifier>().updateSavedChannels(channel),
                  value: context
                      .watch<ChannelsNotifier>()
                      .savedChannels
                      .where((c) => c.id == channel.id)
                      .isNotEmpty,
                );
              },
            ),
          ),
          SizedBox(height: 20),
          RaisedButton(
            onPressed: () async {
              await context.read<ChannelsNotifier>().saveFavourites();
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('Saved')));
            },
            color: Theme.of(context).accentColor,
            child: Text('Save channels'),
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
