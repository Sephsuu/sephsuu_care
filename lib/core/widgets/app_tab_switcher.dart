import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/constants/app_clay.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/constants/app_font_size.dart';
import 'package:sephsuu_care/core/widgets/app_button.dart';

// Sample Usage
// AppTabSwitcher<String>(
//   value: selectedTab,
//   options: const [
//     AppTabOption(value: 'overview', label: 'Overview'),
//     AppTabOption(value: 'history', label: 'History'),
//   ],
//   onChanged: (value) => setState(() => selectedTab = value),
// )

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

/// A controlled tab selector. The parent updates [value] and displays content.
/// Each option should have a unique value.
class AppTabSwitcher<T> extends StatelessWidget {
  final T? value;
  final List<AppTabOption<T>> options;
  final ValueChanged<T> onChanged;
  final bool enabled;
  final double spacing;
  final double runSpacing;
  final WrapAlignment alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? itemPadding;
  final double? width;
  final double height;
  final double borderRadius;
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
  final ButtonStyle? selectedStyle;
  final ButtonStyle? style;

  const AppTabSwitcher({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.enabled = true,
    this.spacing = 8,
    this.runSpacing = 8,
    this.alignment = WrapAlignment.start,
    this.padding,
    this.itemPadding,
    this.width,
    this.height = 44,
    this.borderRadius = 999,
    this.borderColor = AppColors.border,
    this.borderWidth = 1.5,
    this.outerColor = AppColors.light,
    this.outerWidth = 6,
    this.boxShadow = AppClay.shadows,
    this.selectedBackgroundColor = AppColors.pink,
    this.backgroundColor = AppColors.light,
    this.selectedForegroundColor = AppColors.light,
    this.foregroundColor = AppColors.dark,
    this.textStyle,
    this.selectedStyle,
    this.style,
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
            child: Wrap(
              spacing: spacing,
              runSpacing: runSpacing,
              alignment: alignment,
              children: options.map((option) {
                final isSelected = option.value == value;
                final background = isSelected
                    ? selectedBackgroundColor
                    : backgroundColor;
                final foreground = isSelected
                    ? selectedForegroundColor
                    : foregroundColor;
                final buttonStyle = ElevatedButton.styleFrom(
                  backgroundColor: background,
                  foregroundColor: foreground,
                  disabledBackgroundColor: background.withValues(alpha: 0.6),
                  disabledForegroundColor: foreground.withValues(alpha: 0.4),
                  padding:
                      itemPadding ??
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  textStyle:
                      textStyle ??
                      const TextStyle(
                        fontSize: AppFontSize.sm,
                        fontWeight: FontWeight.w600,
                      ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  elevation: isSelected ? 5 : 0,
                  shadowColor: AppClay.shadow,
                  surfaceTintColor: Colors.transparent,
                ).merge(isSelected ? selectedStyle ?? style : style);

                return Semantics(
                  button: true,
                  selected: isSelected,
                  child: AppButton(
                    icon: option.icon,
                    label: Text(option.label),
                    height: height,
                    disabled: !enabled || option.disabled,
                    style: buttonStyle,
                    onPressed: () {
                      if (!isSelected) onChanged(option.value);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
