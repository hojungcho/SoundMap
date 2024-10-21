import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FeatureButtons extends StatefulWidget {
  const FeatureButtons({super.key});

  @override
  State<FeatureButtons> createState() => _FeatureSelectorState();
}

class _FeatureSelectorState extends State<FeatureButtons> {
  var feature = ['title', 'artist', 'tempo', 'lyric', 'first_impression']; // Feature list
  var featureColors = [Colors.orange, Colors.green, Colors.pink, Colors.blue, Colors.purple];
  List<String> selectedFeatures = []; // Selected feature list

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i=0; i<feature.length; i++)
                  InkWell(
                    onTap: (){
                      setState(() {
                        selectedFeatures.contains(feature[i]) ? selectedFeatures.remove(feature[i]) : selectedFeatures.add(feature[i]);
                        _saveSelectedFeaturesToJson();
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.symmetric(horizontal:  10, vertical: 5),
                      decoration: BoxDecoration(
                        color: selectedFeatures.contains(feature[i]) ? featureColors[i] : Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        feature[i],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: selectedFeatures.contains(feature[i]) ? Colors.white : Colors.black
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveSelectedFeaturesToJson() {
    // JSON 데이터 생성
    final jsonData = jsonEncode({'selectedFeatures': selectedFeatures});

    // Blob을 생성하여 파일로 변환
    final bytes = utf8.encode(jsonData);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    // 링크 클릭 없이 자동으로 파일 다운로드 트리거
    html.AnchorElement(href: url)
      ..setAttribute('download', 'selected_features.json')
      ..click(); // 수동 클릭 없이 바로 실행

    html.Url.revokeObjectUrl(url); // 메모리 해제
  }

}
