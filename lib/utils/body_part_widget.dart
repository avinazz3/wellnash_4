import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BodyPartWidget extends StatelessWidget {
  final List<String> paths;
  final String color;

  BodyPartWidget(this.paths, {this.color = '#3f3f3f'});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: paths.map((path) {
        return Positioned.fill(
          child: SvgPicture.string(
            '''
            <svg viewBox="0 0 500 1500">
              <path d="$path" fill="$color"/>
            </svg>
            ''',
          ),
        );
      }).toList(),
    );
  }
}
