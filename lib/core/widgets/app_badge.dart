import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/constants/app_clay.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/constants/app_font_size.dart';

class AppBadge extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;
  final IconData? selectedIcon;
  final bool showIcon;
  final bool showLabel;
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double gap;
  final double iconSize;
  final Color selectedBackgroundColor;
  final Color backgroundColor;
  final Color? selectedBorderColor;
  final Color borderColor;
  final Color selectedForegroundColor;
  final Color foregroundColor;
  final TextStyle? textStyle;
  final List<BoxShadow>? selectedBoxShadow;
  final Duration animationDuration;
  final Curve animationCurve;
  final Color iconColor;
  final Color selectedIconColor;

  const AppBadge({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon = Icons.add_circle_outline_rounded,
    this.selectedIcon = Icons.check_circle_rounded,
    this.showIcon = true,
    this.showLabel = true,
    this.mainAxisAlignment = MainAxisAlignment.start,
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
    this.selectedBoxShadow,
    this.animationDuration = const Duration(milliseconds: 220),
    this.animationCurve = Curves.easeOutCubic,
    this.iconColor = AppColors.dark,
    this.selectedIconColor = AppColors.light,
  });

  @override
  Widget build(BuildContext context) {
    final iconData = selected ? selectedIcon : icon;
    final foreground = selected ? selectedForegroundColor : foregroundColor;
    final resolvedIconColor = selected
      ? selectedIconColor
      : iconColor;

    final badge = AnimatedContainer(
      duration: animationDuration,
      curve: animationCurve,
      padding: padding,
      decoration: BoxDecoration(
        color: selected ? selectedBackgroundColor : backgroundColor,
        gradient: AppClay.sheen(
          selected ? selectedBackgroundColor : backgroundColor,
        ),
        border: selected && selectedBorderColor == null
            ? null
            : Border.all(color: selected ? selectedBorderColor! : borderColor),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: selected
          ? selectedBoxShadow ?? const []
          : const [],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment,
        children: [
          if (showIcon && iconData != null)
            Icon(
              iconData,
              size: iconSize,
              color: resolvedIconColor,
            ),
          Flexible(
            child: ClipRect(
              child: AnimatedSize(
                duration: animationDuration,
                curve: animationCurve,
                alignment: Alignment.centerLeft,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 160),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        sizeFactor: animation,
                        axis: Axis.horizontal,
                        alignment: Alignment.centerLeft,
                        child: child,
                      ),
                    );
                  },
                  child: showLabel
                      ? Padding(
                          key: const ValueKey('badge-label'),
                          padding: EdgeInsets.only(left: gap),
                          child: Text(
                            label,
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.clip,
                            style:
                                textStyle ??
                                TextStyle(
                                  color: foreground,
                                  fontSize: AppFontSize.sm,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        )
                      : const SizedBox.shrink(
                          key: ValueKey('badge-label-hidden'),
                        ),
                ),
              ),
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
