import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BodyPartWidget extends StatelessWidget {
  final List<String> paths;
  final String color;
  final String viewBox;

  BodyPartWidget(this.paths, {
    this.color = '#3f3f3f',
    this.viewBox = '0 0 800 1000', // Adjust this to match your SVG dimensions
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 800 / 1000, // Adjust this to match your SVG aspect ratio
      child: Stack(
        children: paths.map((path) {
          return SvgPicture.string(
            '''
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="$viewBox">
              <path d="$path" fill="$color"/>
            </svg>
            ''',
            fit: BoxFit.contain,
          );
        }).toList(),
      ),
    );
  }
}