import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/constants/app_clay.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/constants/app_font_size.dart';

class AppTabOption<T> {
  final T value;
  final String label;
  final Widget? icon;
  final bool disabled;

  const AppTabOption({
    required this.value,
    required this.label,
    this.icon,
    this.disabled = false,
  });
}

class AppTabSwitcher<T> extends StatelessWidget {
  final T? value;
  final List<AppTabOption<T>> options;
  final ValueChanged<T> onChanged;

  final bool enabled;

  /// Space between each tab.
  final double spacing;

  final double runSpacing;

  /// Padding outside the whole switcher.
  final EdgeInsetsGeometry? padding;

  /// Padding inside each tab.
  final EdgeInsetsGeometry? itemPadding;

  final double? width;
  final double height;

  /// Outer switcher radius.
  final double borderRadius;

  /// Radius of each individual tab.
  final double itemBorderRadius;

  final Color borderColor;
  final double borderWidth;

  final Color outerColor;
  final double outerWidth;

  final List<BoxShadow> boxShadow;

  final Color selectedBackgroundColor;
  final Color backgroundColor;

  final Color selectedForegroundColor;
  final Color foregroundColor;

  final TextStyle? textStyle;

  /// horizontal:
  /// [icon] Label
  ///
  /// vertical:
  /// [icon]
  /// Label
  final Axis itemDirection;

  /// Gap between icon and label.
  final double itemGap;

  /// Makes all tabs occupy equal available width.
  final bool expandItems;

  final Duration animationDuration;
  final Curve animationCurve;

  const AppTabSwitcher({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.enabled = true,
    this.spacing = 4,
    this.runSpacing = 8,
    this.padding,
    this.itemPadding,
    this.width,
    this.height = 48,
    this.borderRadius = 999,
    this.itemBorderRadius = 999,
    this.borderColor = AppColors.border,
    this.borderWidth = 1.5,
    this.outerColor = AppColors.light,
    this.outerWidth = 6,
    this.boxShadow = AppClay.lightShadows,
    this.selectedBackgroundColor = AppColors.pink,
    this.backgroundColor = AppColors.light,
    this.selectedForegroundColor = AppColors.light,
    this.foregroundColor = AppColors.dark,
    this.textStyle,
    this.itemDirection = Axis.horizontal,
    this.itemGap = 8,
    this.expandItems = false,
    this.animationDuration = const Duration(milliseconds: 220),
    this.animationCurve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: SizedBox(
        width: width,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: outerColor,
            gradient: AppClay.sheen(outerColor),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor, width: borderWidth),
            boxShadow: boxShadow,
          ),
          child: Padding(
            padding: EdgeInsets.all(outerWidth),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Use equal-width tabs only if the parent
                // provides a finite width.
                if (expandItems && constraints.hasBoundedWidth) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (var index = 0; index < options.length; index++) ...[
                        Expanded(child: _buildTab(context, options[index])),

                        if (index < options.length - 1)
                          SizedBox(width: spacing),
                      ],
                    ],
                  );
                }

                return Wrap(
                  spacing: spacing,
                  runSpacing: runSpacing,
                  children: [
                    for (final option in options) _buildTab(context, option),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, AppTabOption<T> option) {
    final bool isSelected = option.value == value;
    final bool isDisabled = !enabled || option.disabled;

    final Color background = isSelected
        ? selectedBackgroundColor
        : backgroundColor;

    final Color foreground = isSelected
        ? selectedForegroundColor
        : foregroundColor;

    return Semantics(
      button: true,
      selected: isSelected,
      enabled: !isDisabled,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled
              ? null
              : () {
                  if (!isSelected) {
                    onChanged(option.value);
                  }
                },
          borderRadius: BorderRadius.circular(itemBorderRadius),
          child: AnimatedContainer(
            duration: animationDuration,
            curve: animationCurve,
            height: height,
            padding:
                itemPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDisabled
                  ? background.withValues(alpha: 0.55)
                  : background,
              borderRadius: BorderRadius.circular(itemBorderRadius),

              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: selectedBackgroundColor.withValues(alpha: 0.22),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : const [],
            ),
            child: Center(
              child: Flex(
                direction: itemDirection,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (option.icon != null) ...[
                    IconTheme(
                      data: IconThemeData(
                        color: isDisabled
                            ? foreground.withValues(alpha: 0.4)
                            : foreground,
                      ),
                      child: option.icon!,
                    ),
                    SizedBox(
                      width: itemDirection == Axis.horizontal ? itemGap : 0,
                      height: itemDirection == Axis.vertical ? itemGap : 0,
                    ),
                  ],

                  Flexible(
                    child: Text(
                      option.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style:
                          textStyle?.copyWith(
                            color: isDisabled
                                ? foreground.withValues(alpha: 0.4)
                                : foreground,
                          ) ??
                          TextStyle(
                            color: isDisabled
                                ? foreground.withValues(alpha: 0.4)
                                : foreground,
                            fontSize: AppFontSize.xs,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
