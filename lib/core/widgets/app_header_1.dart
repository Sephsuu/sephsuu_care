import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/constants/app_font_size.dart';

class AppHeader1 extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;
  final TextStyle? style;

  const AppHeader1(
    this.text, {
    super.key,
    this.color = AppColors.dark,
    this.fontSize = AppFontSize.x3l,
    this.fontWeight = FontWeight.w100,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.height,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = GoogleFonts.lilitaOne(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
    );

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: style == null ? defaultStyle : defaultStyle.merge(style),
    );
  }
}
