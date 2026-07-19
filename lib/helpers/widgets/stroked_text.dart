import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StrokedText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color fillColor;
  final Color strokeColor;
  final double strokeWidth;
  final FontWeight fontWeight;
  final double? letterSpacing;
  final double? height;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  const StrokedText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.fillColor,
    required this.strokeColor,
    this.strokeWidth = 3,
    this.fontWeight = FontWeight.w800,
    this.letterSpacing,
    this.height,
    this.maxLines,
    this.overflow,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = GoogleFonts.lilitaOne(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
    );

    return Stack(
      children: [
        Text(
          text,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign,
          style: defaultStyle.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ),
        ),
        Text(
          text,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign,
          style: defaultStyle.copyWith(
            color: fillColor,
          ),
        ),
      ],
    );
  }
}