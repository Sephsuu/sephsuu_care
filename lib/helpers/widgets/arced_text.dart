import 'dart:math' as math;

import 'package:flutter/material.dart';

class ArcedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double width;
  final double height;
  final double radius;

  /// Total arc angle in degrees.
  ///
  /// Smaller value = tighter arc
  /// Bigger value = wider arc
  final double arcDegrees;

  final double rotationFactor;
  final double letterSpacing;

  const ArcedText({
    super.key,
    required this.text,
    this.style,
    this.width = 330,
    this.height = 88,
    this.radius = 130,
    this.arcDegrees = 62,
    this.rotationFactor = 0.5,
    this.letterSpacing = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> characters = text.split('');
    final int lastIndex = characters.length - 1;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          for (int index = 0; index < characters.length; index++)
            Positioned(
              left: width / 2 +
                  math.sin(_letterAngle(index, lastIndex)) * radius -
                  11,
              top: 2 +
                  (1 - math.cos(_letterAngle(index, lastIndex))) * radius,
              child: Transform.rotate(
                angle: _letterAngle(index, lastIndex) * rotationFactor,
                child: Text(
                  characters[index],
                  style: style,
                ),
              ),
            ),
        ],
      ),
    );
  }

  double _letterAngle(int index, int lastIndex) {
    if (lastIndex == 0) return 0;

    final double arcRadians = arcDegrees * math.pi / 180;
    final double adjustedArc = arcRadians * letterSpacing;

    return -adjustedArc / 2 + (adjustedArc * index / lastIndex);
  }
}