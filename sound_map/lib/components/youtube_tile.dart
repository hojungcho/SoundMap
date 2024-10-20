import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeTile extends StatefulWidget {
  final String ytUrl;

  const YoutubeTile({super.key, required this.ytUrl});

  @override
  _YoutubeTileState createState() => _YoutubeTileState();
}

class _YoutubeTileState extends State<YoutubeTile> {
  late YoutubePlayerController _youtubePlayerController;
  Map<String, dynamic>? videoData;

  @override
  void initState() {
    super.initState();
    _initializeYoutubePlayer();
    _fetchVideoInfo();
  }

  void _initializeYoutubePlayer() {
    final videoId = YoutubePlayerController.convertUrlToId(widget.ytUrl) ?? '';
    _youtubePlayerController = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
    _youtubePlayerController.cueVideoById(videoId: videoId);
  }

  Future<void> _fetchVideoInfo() async {
    final videoId = YoutubePlayerController.convertUrlToId(widget.ytUrl);
    if (videoId == null) return;

    try {
      final data = await _fetchVideoDetails(videoId);
      setState(() {
        videoData = data;
      });
    } catch (e) {
      print('Failed to load video info: $e');
    }
  }

  Future<Map<String, dynamic>> _fetchVideoDetails(String videoId) async {
    const apiKey = 'AIzaSyCKlkmjaYfjfgNmS5zjer10LfDF5SaWjIs';
    final url =
        'https://www.googleapis.com/youtube/v3/videos?part=snippet&id=$videoId&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load video details. Status code: ${response.statusCode}');
    }
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
            ? const Center(child: CircularProgressIndicator())
            : _buildVideoContent(),
      ),
    );
  }

  Widget _buildVideoContent() {
    final videoSnippet = videoData!['items'][0]['snippet'];
    final videoTitle = videoSnippet['title'] ?? 'No Title';
    final channelTitle = videoSnippet['channelTitle'] ?? 'No Channel';

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
        _buildText(videoTitle, 20, Colors.black, 2),
        _buildText(channelTitle, 15, Colors.grey, 1),
      ],
    );
  }

  Widget _buildText(String text, double fontSize, Color color, int maxLines) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines,
        style: TextStyle(fontSize: fontSize, color: color),
      ),
    );
  }
}
