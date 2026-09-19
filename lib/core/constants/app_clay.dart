import 'package:flutter/material.dart';

/// Shared raised clay surface defaults. Widgets may override these values.
abstract final class AppClay {
  static const double radius = 24;
  static const Color surface = Color(0xFFF3EFF8);
  static const Color edge = Color(0xFFD7CEE2);
  static const Color shadow = Color(0x4076688C);
  static const List<BoxShadow> shadows = [
    BoxShadow(color: shadow, blurRadius: 16, offset: Offset(6, 8)),
    BoxShadow(color: Color(0x2476688C), blurRadius: 3, offset: Offset(1, 3)),
  ];
  static const List<BoxShadow> lightShadows = [
    BoxShadow(
      color: Color(0x2076688C),
      blurRadius: 10,
      offset: Offset(3, 4),
    ),
    BoxShadow(
      color: Color(0x1476688C),
      blurRadius: 2,
      offset: Offset(1, 2),
    ),
  ];
  
  static const List<Shadow> textShadows = [];

  static LinearGradient sheen(Color color) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: const [0, 0.45, 1],
    colors: [
      color,
      color,
      Color.lerp(
        color,
        const Color(0xFF8D7EA3).withValues(alpha: color.a),
        0.10,
      )!,
    ],
  );
}
