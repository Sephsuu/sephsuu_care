import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/constants/app_font_size.dart';

class AppBadge extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;
  final IconData? selectedIcon;
  final bool showIcon;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double gap;
  final double iconSize;
  final Color selectedBackgroundColor;
  final Color backgroundColor;
  final Color selectedBorderColor;
  final Color borderColor;
  final Color selectedForegroundColor;
  final Color foregroundColor;
  final TextStyle? textStyle;

  const AppBadge({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon = Icons.add_circle_outline_rounded,
    this.selectedIcon = Icons.check_circle_rounded,
    this.showIcon = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    this.borderRadius = 999,
    this.gap = 7,
    this.iconSize = 17,
    this.selectedBackgroundColor = AppColors.pink,
    this.backgroundColor = AppColors.light,
    this.selectedBorderColor = AppColors.pink,
    this.borderColor = AppColors.lightpink,
    this.selectedForegroundColor = AppColors.light,
    this.foregroundColor = AppColors.dark,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final iconData = selected ? selectedIcon : icon;
    final foreground = selected ? selectedForegroundColor : foregroundColor;
    final iconColor = selected ? selectedForegroundColor : selectedBorderColor;

    final badge = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: padding,
      decoration: BoxDecoration(
        color: selected ? selectedBackgroundColor : backgroundColor,
        border: Border.all(color: selected ? selectedBorderColor : borderColor),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon && iconData != null) ...[
            Icon(iconData, size: iconSize, color: iconColor),
            SizedBox(width: gap),
          ],
          Text(
            label,
            style:
                textStyle ??
                TextStyle(
                  color: foreground,
                  fontSize: AppFontSize.sm,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );

    if (onTap == null) return badge;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: badge,
    );
  }
}
