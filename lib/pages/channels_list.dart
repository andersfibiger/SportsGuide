import 'dart:ui';
import 'package:SportsGuide/change_notifiers/channels_notifier.dart';
import 'package:SportsGuide/change_notifiers/tv_guide_notifier.dart';
import 'package:SportsGuide/common/button.dart';
import 'package:SportsGuide/common/search_field_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChannelsList extends StatelessWidget {
  const ChannelsList();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchFieldContainer(
              child: TextField(
                onChanged: (query) =>
                    context.read<ChannelsNotifier>().filterChannels(query),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                ),
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: context.watch<ChannelsNotifier>().channels.length,
              itemBuilder: (context, index) {
                final channel =
                    context.read<ChannelsNotifier>().channels[index];
                return Column(
                  children: [
                    Container(
                      // color: Theme.of(context).cardColor,
                      child: CheckboxListTile(
                        title: Text(channel.title),
                        secondary: Image.network(
                          channel.logo,
                          height: 40,
                          width: 40,
                        ),
                        onChanged: (_) => context
                            .read<ChannelsNotifier>()
                            .updateSavedChannels(channel),
                        value: context
                            .watch<ChannelsNotifier>()
                            .savedChannels
                            .where((c) => c.id == channel.id)
                            .isNotEmpty,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Button(
            onPressed: () async {
              await context.read<ChannelsNotifier>().saveFavourites();
              await context.read<TvGuideNotifier>().fetchSports();
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('Saved')));
            },
            child: Text('Save channels'),
            iconData: Icons.save,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
