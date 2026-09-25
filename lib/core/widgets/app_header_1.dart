import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/constants/app_clay.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/constants/app_font_size.dart';
import 'package:sephsuu_care/helpers/widgets/stroked_text.dart';

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
  final Color borderColor;
  final double borderWidth;
  final List<Shadow> shadows;

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
    this.borderColor = Colors.white,
    this.borderWidth = 3,
    this.shadows = AppClay.lightShadows,
  }) : assert(borderWidth >= 0);

  @override
  Widget build(BuildContext context) {
    final defaultStyle = GoogleFonts.lilitaOne(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      shadows: shadows,
    );
    final effectiveStyle = defaultStyle.merge(style);

    return StrokedText(
      text: text,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fillColor: color,
      strokeColor: borderColor,
      strokeWidth: borderWidth,
      shadows: effectiveStyle.shadows,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: effectiveStyle,
    );
  }
}
