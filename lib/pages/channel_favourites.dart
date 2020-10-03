import 'dart:ui';
import 'package:SportsGuide/change_notifiers/channels.dart';
import 'package:SportsGuide/models/channel.dart';
import 'package:SportsGuide/services/tv_guide_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class ChannelFavourites extends StatelessWidget {
  const ChannelFavourites();

  Future<List<Channel>> _getChannels() async {
    final tvGuideService = GetIt.I<ITvGuideService>();
    return await tvGuideService.getChannels();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<Channel>>(
        future: _getChannels(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return SizedBox.shrink();

          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.connectionState == ConnectionState.waiting)
            return SizedBox.shrink();

          return Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 250,
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    final channel = snapshot.data[index];
                    return CheckboxListTile(
                      title: Text(channel.title),
                      secondary: Image.network(
                        channel.logo,
                        height: 40,
                        width: 40,
                      ),
                      onChanged: (_) => context
                          .read<Channels>()
                          .updateChannelsById(channel.id),
                      value: context
                          .watch<Channels>()
                          .channelIds
                          .contains(channel.id),
                    );
                  },
                ),
              ),
              Container(
                child: RaisedButton(
                  onPressed: () async {
                    await context.read<Channels>().saveFavourites();
                  },
                  child: Text('Save favourites'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}