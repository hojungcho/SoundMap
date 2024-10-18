// feature filtering 기반

import 'dart:convert'; // json decoding
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      // rootBundle을 통해 assets에서 파일을 불러옴
      final String response = await rootBundle.loadString('assets/video_info.json');
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
      padding: const EdgeInsets.only(top:40.0, left: 20.0, right: 20.0),
      child: SizedBox(
        width:  MediaQuery.of(context).size.width * 0.4,

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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 썸네일 이미지
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          thumbnailUrl,
                          width: 100,
                          //width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // title
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
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
                          SizedBox(height: 5),

                          // uploader
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text(
                              'Uploaded by: ${video['uploader']}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        )
      ),
    );
  }
}
