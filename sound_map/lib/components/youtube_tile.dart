import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

const String apiKey = 'AIzaSyCKlkmjaYfjfgNmS5zjer10LfDF5SaWjIs';

class YoutubeTile extends StatefulWidget {
  final String ytUrl; // url 전달 변수

  const YoutubeTile({super.key, required this.ytUrl});

  @override
  _YoutubeTileState createState() => _YoutubeTileState();
}

class _YoutubeTileState extends State<YoutubeTile> {
  Map<String, dynamic>? videoData; // 영상 정보 저장 변수
  String? videoId;

  @override
  void initState() {
    super.initState();

    _fetchVideoInfo();

    videoId = YoutubePlayer.convertUrlToId(widget.ytUrl);

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: 450,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: videoData == null || videoData!['items'] == null
            ? Center(child: Text('Loading video info...'))  // Loading state
            :Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (videoData != null && videoData!['items'] != null)
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.network(
                    'https://img.youtube.com/vi/$videoId/0.jpg', // 썸네일 URL 추출
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object expection, StackTrace? stackTrace){
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error, color: Colors.red, size: 100),
                          SizedBox(height: 5),
                          Text('Failed to load image', style: TextStyle(color: Colors.red)),
                        ],
                      );
                    },
                  ),
                ),
              ),

            const SizedBox(height: 10.0),

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                videoData!['items'][0]['snippet']['title'] ?? 'No Title',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                videoData!['items'][0]['snippet']['channelTitle'] ?? 'No Channel',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 비디오 ID로 YouTube API에서 영상 정보 가져오기
  Future<void> _fetchVideoInfo() async {
    String youtubeUrl = widget.ytUrl;

    // YoutubePlayer.convertUrlToId()로 비디오 ID 추출
    String? videoId = YoutubePlayer.convertUrlToId(youtubeUrl);

    if (videoId != null) {
      try {
        final data = await fetchVideoDetails(videoId);
        setState(() {
          videoData = data;  // 영상 정보를 저장
        });
      } catch (e) {
        setState(() {
          videoData = null;  // 실패 시 videoData를 null로 설정
        });
      }
    } else {
      setState(() {
        videoData = null;  // 유효하지 않은 URL일 경우
      });
    }
  }

  // YouTube API를 통해 영상 정보를 가져오는 함수
  Future<Map<String, dynamic>> fetchVideoDetails(String videoId) async {
    final url = 'https://www.googleapis.com/youtube/v3/videos?part=snippet&id=$videoId&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // 응답 JSON을 디코딩하여 반환
      return jsonDecode(response.body);
    } else {
      throw Exception('비디오 정보를 불러오는 데 실패했습니다. 상태 코드: ${response.statusCode}');
    }
  }
}
