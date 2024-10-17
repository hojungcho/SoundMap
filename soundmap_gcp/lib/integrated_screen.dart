import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart' show rootBundle;

class IntegratedScreen extends StatefulWidget {
  @override
  _IntegratedScreenState createState() => _IntegratedScreenState();
}

class _IntegratedScreenState extends State<IntegratedScreen> {
  TextEditingController _youtubeUrlController = TextEditingController();
  List<dynamic> songs = [];
  bool isLoading = false; // Initially set to false
  String trimmedAudioUrl = '';
  bool showSongList = false; // Control when to show the song list

  // Process the video and load the song list
  Future<void> _processVideo() async {
    String apiUrl = 'https://flask-youtube-app-551851244656.us-central1.run.app/convert';  // Your Cloud Run URL
    String url = _youtubeUrlController.text;

    if (!_isValidYouTubeUrl(url)) {
      _showErrorDialog('Invalid YouTube URL');
      return;
    }

    setState(() {
      isLoading = true; // Start processing, set the button to "Processing..."
      showSongList = false; // Hide the song list until processing is done
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'url': url}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['url'] != null) {
          setState(() {
            trimmedAudioUrl = 'https://flask-youtube-app-551851244656.us-central1.run.app' + jsonResponse['url'];
            isLoading = false;
          });
          _loadSongList(); // Load the song list after processing
        } else {
          _showErrorDialog('Error processing video.');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        _showErrorDialog('Failed to process video: ${response.body}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to connect to server.');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Load the song list from assets
  Future<void> _loadSongList() async {
    final String jsonString = await rootBundle.loadString('assets/video_info.json');
    setState(() {
      songs = json.decode(jsonString).take(5).toList();
      showSongList = true; // Show the song list after it's loaded
    });
  }

  bool _isValidYouTubeUrl(String url) {
    final youtubeRegex = RegExp(r"^(https?\:\/\/)?(www\.youtube\.com|youtu\.?be)\/.+$");
    return youtubeRegex.hasMatch(url);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void downloadFile(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Audio Trimmer & Song List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // URL Input Field
            TextField(
              controller: _youtubeUrlController,
              decoration: InputDecoration(
                labelText: 'Enter YouTube URL',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            
            // Process Button
            ElevatedButton(
              onPressed: isLoading ? null : _processVideo,
              child: Text(isLoading ? 'Processing...' : 'Extract Audio'),
            ),
            
            SizedBox(height: 20),
            
            // Trimmed Audio Download Button
            if (trimmedAudioUrl.isNotEmpty)
              Column(
                children: [
                  Text('Trimmed Audio (15-30 seconds) is ready for download.'),
                  ElevatedButton(
                    onPressed: () => downloadFile(trimmedAudioUrl),
                    child: Text('Download Trimmed Audio'),
                  ),
                ],
              ),

            SizedBox(height: 20),

            // Song List Section (only show after audio extraction)
            if (showSongList)
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
      ),
    );
  }
}
