import 'dart:convert'; // json decoding
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VideoList_2 extends StatefulWidget {
  const VideoList_2({super.key});

  @override
  State<VideoList_2> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList_2> {
  List<dynamic> _videoList = [];

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  // assets에서 JSON 파일 불러오기
  Future<void> _loadJsonData() async {
    try {
      final String response =
      await rootBundle.loadString('assets/video_info.json');
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
    return Container(
      child: _videoList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Title',
              style: TextStyle(color: Colors.white)
            )),
            DataColumn(label: Text('Uploader',
                style: TextStyle(color: Colors.white)
            )),
          ],
          rows: _videoList.map<DataRow>((video) {
            return DataRow(cells: [
              DataCell(Text(video['title'],
                  style: TextStyle(color: Colors.white)
              )),
              DataCell(Text(video['uploader'],
                  style: TextStyle(color: Colors.white)
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}