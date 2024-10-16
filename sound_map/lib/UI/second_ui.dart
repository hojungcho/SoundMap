import 'package:flutter/material.dart';

import '../components/feature_buttons.dart';
import '../components/youtube_tile.dart';

class SecondUi extends StatelessWidget {
  final String yt_url;

  const SecondUi({super.key, required this.yt_url});

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
                children: [
                  //feature buttons
                  FeatureButtons(),

                  // youtube tile
                  YoutubeTile(ytUrl: yt_url),
                ]
            ),
          ),

          // song recommendation tiles

        ],
      ),
    );
  }
}
