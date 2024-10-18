import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:just_audio/just_audio.dart';

class AudioButton extends StatefulWidget {
  final String ytUrl;

  const AudioButton({Key? key, required this.ytUrl}) : super(key: key);

  @override
  _AudioButtonState createState() => _AudioButtonState();
}

class _AudioButtonState extends State<AudioButton> {
  final YoutubeExplode _youtubeExplode = YoutubeExplode();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isLoading = true;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _loadAudioStream();
  }

  Future<void> _loadAudioStream() async {
    try {
      var videoId = VideoId(widget.ytUrl);
      var manifest = await _youtubeExplode.videos.streamsClient.getManifest(videoId);
      var audioStream = manifest.audioOnly.withHighestBitrate();
      var audioStreamUrl = audioStream.url;

      await _audioPlayer.setUrl(audioStreamUrl.toString());

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  void _togglePlayPause() {
    if (isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _youtubeExplode.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator()
        : ElevatedButton(
      onPressed: _togglePlayPause,
      child: Text(isPlaying ? 'Pause' : 'Play'),
    );
  }
}
