import 'package:flutter/material.dart';

class FeatureButtons extends StatefulWidget {
  const FeatureButtons({super.key});

  @override
  State<FeatureButtons> createState() => _FeatureSelectorState();
}

class _FeatureSelectorState extends State<FeatureButtons> {
  var feature = ['melody', 'tempo', 'bpm', 'artist', 'lyrics']; // Feature list
  var feature_colors = [Colors.orange, Colors.green, Colors.pink, Colors.blue, Colors.purple];
  List<String> featureList = []; // Selected feature list

  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Padding(
        padding: const EdgeInsets.only(top:20.0, left: 20.0, right: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i=0; i<feature.length; i++)
              InkWell(
                onTap: (){
                  setState(() {
                    featureList.contains(feature[i]) ? featureList.remove(feature[i]) : featureList.add(feature[i]);
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.symmetric(horizontal:  10, vertical: 5),
                  decoration: BoxDecoration(
                    color: featureList.contains(feature[i]) ? feature_colors[i] : Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(feature[i],
                    style: TextStyle(color: featureList.contains(feature[i]) ? Colors.white : feature_colors[i]),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
