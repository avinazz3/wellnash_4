import 'package:flutter/material.dart';
import 'front_view.dart';
import 'back_view.dart';

class MuscleHighlighter extends StatefulWidget {
  @override
  _MuscleHighlighterState createState() => _MuscleHighlighterState();
}

class _MuscleHighlighterState extends State<MuscleHighlighter> {
  bool isFrontView = true;

  void toggleView() {
    setState(() {
      isFrontView = !isFrontView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: isFrontView ? FrontView() : BackView(),
        ),
        ElevatedButton(
          onPressed: toggleView,
          child: Text(isFrontView ? 'Show Back View' : 'Show Front View'),
        ),
      ],
    );
  }
}
