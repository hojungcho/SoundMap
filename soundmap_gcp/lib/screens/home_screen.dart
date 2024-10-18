import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController youtubeUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Audio Extractor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: youtubeUrlController,
              decoration: InputDecoration(
                labelText: 'Enter YouTube URL',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String url = youtubeUrlController.text;
                if (url.isNotEmpty && _isValidYouTubeUrl(url)) {
                  // If valid, navigate to the video screen
                  Navigator.pushNamed(
                    context,
                    '/video',
                    arguments: youtubeUrlController.text,
                  );
                } else {
                  // Show error message if the URL is invalid
                  _showErrorDialog(context, 'Invalid YouTube URL');
                }
              },
              child: Text('Extract Audio'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to validate YouTube URL
  bool _isValidYouTubeUrl(String url) {
    final youtubeRegex = RegExp(
        r"^(https?\:\/\/)?(www\.youtube\.com|youtu\.?be)\/.+$");
    return youtubeRegex.hasMatch(url);
  }

  // Function to show error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
