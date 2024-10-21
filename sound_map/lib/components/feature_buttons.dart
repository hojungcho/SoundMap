import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
                for (var i = 0; i < feature.length; i++)
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedFeatures.contains(feature[i])
                            ? selectedFeatures.remove(feature[i])
                            : selectedFeatures.add(feature[i]);
                        _sendSelectedFeaturesToServer();
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: selectedFeatures.contains(feature[i]) ? featureColors[i] : Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        feature[i],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: selectedFeatures.contains(feature[i]) ? Colors.white : Colors.black),
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

  // Method to send the selected features to the Python backend
  Future<void> _sendSelectedFeaturesToServer() async {
    final jsonData = jsonEncode({'selectedFeatures': selectedFeatures});
    final url = Uri.parse('http://localhost:5000/save_features'); // Replace with your Python backend URL

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonData,
      );
      if (response.statusCode == 200) {
        print("Features saved successfully!");
      } else {
        print("Failed to save features. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error occurred: $error");
    }
  }
}
