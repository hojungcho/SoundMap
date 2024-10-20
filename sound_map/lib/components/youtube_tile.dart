import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

const String apiKey = 'AIzaSyCKlkmjaYfjfgNmS5zjer10LfDF5SaWjIs';

class YoutubeTile extends StatefulWidget {
  final String ytUrl; // URL 전달 변수

  const YoutubeTile({super.key, required this.ytUrl});

  @override
  _YoutubeTileState createState() => _YoutubeTileState();
}

class _YoutubeTileState extends State<YoutubeTile> {
  late YoutubePlayerController _youtubePlayerController;
  Map<String, dynamic>? videoData; // 영상 정보 저장 변수

  @override
  void initState() {
    super.initState();
    _initializeYoutubePlayer();
    _fetchVideoInfo();
  }

  void _initializeYoutubePlayer() {
    final videoId = YoutubePlayerController.convertUrlToId(widget.ytUrl) ?? '';
    _youtubePlayerController = YoutubePlayerController(
      params: YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
    _youtubePlayerController.cueVideoById(videoId: videoId);
  }

  @override
  void dispose() {
    _youtubePlayerController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: 450,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: videoData == null
            ? const Center(child: CircularProgressIndicator()) // 로딩 표시
            : _buildVideoContent(),
      ),
    );
  }

  Widget _buildVideoContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: YoutubePlayer(
            controller: _youtubePlayerController,
            aspectRatio: 16 / 9,
          ),
        ),
        const SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            videoData!['items'][0]['snippet']['title'] ?? 'No Title',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            videoData!['items'][0]['snippet']['channelTitle'] ?? 'No Channel',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  // 비디오 ID로 YouTube API에서 영상 정보 가져오기
  Future<void> _fetchVideoInfo() async {
    final videoId = YoutubePlayerController.convertUrlToId(widget.ytUrl);
    if (videoId == null) {
      setState(() {
        videoData = null;
      });
      return;
    }

    try {
      final data = await fetchVideoDetails(videoId);
      setState(() {
        videoData = data; // 영상 정보를 저장
      });
    } catch (e) {
      setState(() {
        videoData = null;
      });
    }
  }

  // YouTube API를 통해 영상 정보를 가져오는 함수
  Future<Map<String, dynamic>> fetchVideoDetails(String videoId) async {
    final url = 'https://www.googleapis.com/youtube/v3/videos?part=snippet&id=$videoId&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load video details. Status code: ${response.statusCode}');
    }
  }
}
