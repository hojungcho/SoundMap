// feature filtering 기반
import 'dart:convert'; // json decoding
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoList_1 extends StatefulWidget {
  const VideoList_1({super.key});

  @override
  State<VideoList_1> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList_1> {
  List<dynamic> _videoList = [];

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  // assets에서 JSON 파일 불러오기
  Future<void> _loadJsonData() async {
    try {
      final String response = await rootBundle.loadString('assets/recommendation.json');
      final List<dynamic> jsonData = jsonDecode(response);
      setState(() {
        _videoList = jsonData;
      });
    } catch (e) {
      print('Error reading JSON file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: SizedBox(
          width:  MediaQuery.of(context).size.width * 0.5,
          height: 450,

          child: _videoList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: _videoList.length,
            itemBuilder: (context, index) {
              final video = _videoList[index];
              final String videoId = video['id'];
              final String thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';

              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),

                  child: InkWell(
                    onTap: () async {
                      final String videoUrl = 'https://www.youtube.com/watch?v=$videoId';
                      if (await canLaunchUrl(Uri.parse(videoUrl))) {
                        await launchUrl(Uri.parse(videoUrl));
                      } else {
                        throw 'Could not launch $videoUrl';
                      }
                    },

                    child: SizedBox(
                      // 카드 크기
                      width:  MediaQuery.of(context).size.width * 0.5,
                      height: 100,

                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          // 썸네일 이미지
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset('assets/thumbnails/$videoId.jpg')
                            ),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // title
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: SizedBox(
                                  width: (MediaQuery.of(context).size.width * 0.4 - 200 ),
                                  child: Text(
                                    video['title'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),

                              // uploader
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: SizedBox(
                                  width: (MediaQuery.of(context).size.width * 0.4 - 200 ),
                                  child: Text(
                                    '${video['artist']}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          )
      ),
    );
  }
}