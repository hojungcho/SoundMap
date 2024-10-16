import 'package:flutter/material.dart';

class FirstUi extends StatelessWidget {
  const FirstUi({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'This is the first UI with service explanation.',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }
}
