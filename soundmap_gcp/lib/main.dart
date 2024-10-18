import 'package:flutter/material.dart';
import 'integrated_screen.dart';  // Import the IntegratedScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Audio Trimmer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IntegratedScreen(),  // Use IntegratedScreen as the home screen
    );
  }
}
