import 'package:SportsGuide/change_notifiers/channels_notifier.dart';
import 'package:SportsGuide/models/channel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChannelTile extends StatelessWidget {
  const ChannelTile({
    Key key,
    @required this.channel,
  }) : super(key: key);

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: CheckboxListTile(
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
      ),
    );
  }
}
