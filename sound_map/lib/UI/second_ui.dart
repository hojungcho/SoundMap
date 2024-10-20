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
                      //feature buttons
                      FeatureButtons(),

                      // youtube tile
                      YoutubeTile(ytUrl: yt_url),
                    ]
                ),
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Feature List',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0
                        ),
                      ),
                    ),

                    // song recommendation tiles - feature filter
                    VideoList_1(),
                  ],
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Basic List',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
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
