import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'back_body_parts.dart';

class BackView extends StatelessWidget {
  final void Function(String)? onPartSelected;

  const BackView({Key? key, this.onPartSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: back_body_parts.map((part) {
        return GestureDetector(
          onTap: () => onPartSelected?.call(part['slug']),
          child: SvgPicture.string(
            _buildSvgString(part['paths'], part['color']),
            allowDrawingOutsideViewBox: true,
          ),
        );
      }).toList(),
    );
  }

  String _buildSvgString(List<String> paths, String color) {
    final pathsString = paths.map((path) => '<path d="$path" fill="$color" />').join();
    return '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 1000">$pathsString</svg>';
  }
}
