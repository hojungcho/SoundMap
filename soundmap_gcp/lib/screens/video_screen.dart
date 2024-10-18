import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class VideoScreen extends StatefulWidget {
  final String youtubeUrl;

  VideoScreen({required this.youtubeUrl});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  bool isLoading = false;
  String trimmedAudioUrl = '';
  List<dynamic> songs = [];  // To store the song list

  @override
  void initState() {
    super.initState();
    convertAndTrimVideo(widget.youtubeUrl);  // Convert and trim the video to WAV
    loadSongs();  // Load the previous songs list
  }

  // Function to convert and trim YouTube video to WAV
  Future<void> convertAndTrimVideo(String videoUrl) async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse('http://localhost:5000/convert'),  // Ensure Flask is running
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'url': videoUrl}),
      );

      if (response.statusCode == 200) {
        setState(() {
          // Set the trimmed audio URL to download
          trimmedAudioUrl = 'http://localhost:5000/static/trimmed_audio.wav';
        });
        print('Trimmed audio is ready for download...');
      } else {
        print('Failed to convert and trim video: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to load previous songs from JSON (assets/video_info.json)
  Future<void> loadSongs() async {
    String jsonString = await DefaultAssetBundle.of(context).loadString('assets/video_info.json');
    List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      songs = jsonData.take(5).toList();  // Display the first 5 songs
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Trimmer & Song List'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())  // Show a loading spinner while processing
          : Column(
              children: [
                if (trimmedAudioUrl.isNotEmpty)
                  Column(
                    children: [
                      Text('Trimmed Audio (15-30 seconds) is ready for download.'),
                      ElevatedButton(
                        onPressed: () {
                          // Open the trimmed audio URL in the browser to download
                          downloadFile(trimmedAudioUrl);
                        },
                        child: Text('Download Trimmed Audio'),
                      ),
                    ],
                  ),
                SizedBox(height: 20),  // Add some space between the player and the song list

                // Song List Section Below the Player
                Expanded(
                  child: ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(songs[index]['title']),
                        subtitle: Text(songs[index]['uploader']),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  // Function to download the trimmed audio file
  void downloadFile(String url) async {
    // Open the URL in the default browser for download
    if (await canLaunch(url)) {
      await launch(url);  // Trigger the download in a new browser tab
    } else {
      throw 'Could not launch $url';
    }
  }
}
