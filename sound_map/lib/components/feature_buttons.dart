import 'package:flutter/material.dart';

class FeatureButtons extends StatefulWidget {
  const FeatureButtons({super.key});

  @override
  State<FeatureButtons> createState() => _FeatureSelectorState();
}

class _FeatureSelectorState extends State<FeatureButtons> {
  var feature = ['title', 'artist', 'tempo', 'lyric', 'first_impression']; // Feature list
  var feature_colors = [Colors.orange, Colors.green, Colors.pink, Colors.blue, Colors.purple];
  List<String> selected_feature = []; // Selected feature list

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
                        selected_feature.contains(feature[i]) ? selected_feature.remove(feature[i]) : selected_feature.add(feature[i]);
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.symmetric(horizontal:  10, vertical: 5),
                      decoration: BoxDecoration(
                        color: selected_feature.contains(feature[i]) ? feature_colors[i] : Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        feature[i],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: selected_feature.contains(feature[i]) ? Colors.white : Colors.black
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
}
