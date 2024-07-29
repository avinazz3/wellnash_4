import 'package:flutter/material.dart';

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
          child: Image.asset(
            isFrontView ? 'front_view.jpg' : 'back_view.jpg',
            fit: BoxFit.contain,
          ),
        ),
        ElevatedButton(
          onPressed: toggleView,
          child: Text(isFrontView ? 'Show Back View' : 'Show Front View'),
        ),
      ],
    );
  }
}
