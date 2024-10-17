import 'package:flutter/material.dart';
import 'package:sound_map/components/recommendation_tile.dart';

import '../components/feature_buttons.dart';
import '../components/youtube_tile.dart';

class SecondUi extends StatelessWidget {
  final String yt_url;

  const SecondUi({super.key, required this.yt_url});

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                      children: [
                        //feature buttons
                        FeatureButtons(),

                        // youtube tile
                        YoutubeTile(ytUrl: yt_url),
                      ]
                  ),
                ),

                // song recommendation tiles - feature filter
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: VideoList(),
                ),
              ],
            ),
          ),

          // song recommendation tiles - default
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              color: Colors.white,
                child: Text('RECOMMENDATION_TABLE')
            ),
          ),
        ],
      ),
    );
  }
}
