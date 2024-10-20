import 'package:flutter/material.dart';
import 'package:sound_map/components/recommendation_table.dart';
import 'package:sound_map/components/recommendation_tile.dart';

import '../components/feature_buttons.dart';
import '../components/youtube_tile.dart';

class SecondUi extends StatelessWidget {
  final String yt_url;

  const SecondUi({super.key, required this.yt_url});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        SizedBox(
          height:550,
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                    children: [
                      const SizedBox(height: 30),

                      //feature buttons
                      FeatureButtons(),

                      const SizedBox(height: 10),

                      // youtube tile
                      YoutubeTile(ytUrl: yt_url),
                    ]
                ),
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  children: [
                    const SizedBox(height: 30),

                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        'Feature List',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // song recommendation tiles - feature filter
                    VideoList_1(),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Basic List',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                ),
              ),
            ],
          ),
        ),

        // song recommendation tiles - default
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: VideoList_2(),
          ),
        ),
      ],
    );
  }
}
