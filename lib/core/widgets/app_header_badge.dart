import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/constants/app_clay.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/constants/app_font_size.dart';

class AppHeaderBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color textColor;
  final double iconSize;
  final EdgeInsetsGeometry padding;
  final double gap;
  final double borderRadius;
  final TextStyle? textStyle;
  final bool showIcon;
  final List<BoxShadow>? boxShadow;

  const AppHeaderBadge({
    super.key,
    required this.label,
    this.icon = Icons.favorite_rounded,
    this.backgroundColor = const Color(0xBDFFFFFF),
    this.borderColor = AppColors.light,
    this.iconColor = AppColors.pink,
    this.textColor = AppColors.dark,
    this.iconSize = 18,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    this.gap = 7,
    this.borderRadius = 999,
    this.textStyle,
    this.showIcon = true,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        gradient: AppClay.sheen(backgroundColor),
        boxShadow: boxShadow ?? AppClay.shadows,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(icon, color: iconColor, size: iconSize),
            SizedBox(width: gap),
          ],
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style:
                  textStyle ??
                  TextStyle(
                    color: textColor,
                    fontSize: AppFontSize.xs,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
