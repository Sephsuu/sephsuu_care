import 'package:flutter/material.dart';

class AppRadioOption<T> {
  final String label;
  final T value;
  final String? id;
  final bool disabled;
  final String? description;
  final Widget? leading;

  const AppRadioOption({
    required this.label,
    required this.value,
    this.id,
    this.disabled = false,
    this.description,
    this.leading,
  });
}

class AppRadioGroup<T> extends StatelessWidget {
  final String? label;
  final String? name;
  final T? value;
  final ValueChanged<T?> onChanged;
  final List<AppRadioOption<T>> options;
  final bool enabled;
  final Axis direction;
  final WrapAlignment alignment;
  final double spacing;
  final double runSpacing;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? itemPadding;
  final TextStyle? labelStyle;
  final TextStyle? optionLabelStyle;
  final TextStyle? descriptionStyle;
  final Color? activeColor;
  final Color? fillColor;
  final Color? borderColor;
  final double borderRadius;
  final bool bordered;
  final bool required;
  final String? Function(T?)? validator;

  const AppRadioGroup({
    super.key,
    this.label,
    this.name,
    required this.value,
    required this.onChanged,
    required this.options,
    this.enabled = true,
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.spacing = 16,
    this.runSpacing = 10,
    this.padding,
    this.itemPadding,
    this.labelStyle,
    this.optionLabelStyle,
    this.descriptionStyle,
    this.activeColor,
    this.fillColor,
    this.borderColor,
    this.borderRadius = 8,
    this.bordered = false,
    this.required = false,
    this.validator,
  });

  void _handleChange(FormFieldState<T> field, AppRadioOption<T> option) {
    if (!enabled || option.disabled) return;

    field.didChange(option.value);
    onChanged(option.value);
  }

  @override
  Widget build(BuildContext context) {
    final resolvedActiveColor =
        activeColor ?? Theme.of(context).colorScheme.primary;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: FormField<T>(
        initialValue: value,
        validator: (selectedValue) {
          if (required && selectedValue == null) {
            return '${label ?? 'Selection'} is required';
          }

          return validator?.call(selectedValue);
        },
        builder: (field) {
          final selectedValue = field.value ?? value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (label != null) ...[
                Text(
                  label!,
                  style:
                      labelStyle ??
                      const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF374151),
                      ),
                ),
                const SizedBox(height: 8),
              ],
              RadioGroup<T>(
                groupValue: selectedValue,
                onChanged: (nextValue) {
                  if (!enabled || nextValue == null) return;

                  final selectedOption = options.firstWhere(
                    (option) => option.value == nextValue,
                  );
                  _handleChange(field, selectedOption);
                },
                child: Wrap(
                  direction: direction,
                  alignment: alignment,
                  spacing: spacing,
                  runSpacing: runSpacing,
                  children: [
                    for (var index = 0; index < options.length; index++)
                      _AppRadioTile<T>(
                        option: options[index],
                        selectedValue: selectedValue,
                        enabled: enabled,
                        activeColor: resolvedActiveColor,
                        fillColor: fillColor,
                        borderColor: borderColor,
                        borderRadius: borderRadius,
                        bordered: bordered,
                        itemPadding: itemPadding,
                        optionLabelStyle: optionLabelStyle,
                        descriptionStyle: descriptionStyle,
                        onTap: () => _handleChange(field, options[index]),
                      ),
                  ],
                ),
              ),
              if (field.hasError) ...[
                const SizedBox(height: 6),
                Text(
                  field.errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _AppRadioTile<T> extends StatelessWidget {
  final AppRadioOption<T> option;
  final T? selectedValue;
  final bool enabled;
  final Color activeColor;
  final Color? fillColor;
  final Color? borderColor;
  final double borderRadius;
  final bool bordered;
  final EdgeInsetsGeometry? itemPadding;
  final TextStyle? optionLabelStyle;
  final TextStyle? descriptionStyle;
  final VoidCallback onTap;

  const _AppRadioTile({
    required this.option,
    required this.selectedValue,
    required this.enabled,
    required this.activeColor,
    this.fillColor,
    this.borderColor,
    required this.borderRadius,
    required this.bordered,
    this.itemPadding,
    this.optionLabelStyle,
    this.descriptionStyle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedValue == option.value;
    final isEnabled = enabled && !option.disabled;
    final resolvedBorderColor = isSelected
        ? activeColor
        : borderColor ?? Colors.grey.shade300;

    Widget child = InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Padding(
        padding:
            itemPadding ??
            EdgeInsets.symmetric(
              horizontal: bordered ? 12 : 0,
              vertical: bordered ? 10 : 0,
            ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: option.description == null
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Radio<T>(
              value: option.value,
              activeColor: activeColor,
              enabled: isEnabled,
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            if (option.leading != null) ...[
              const SizedBox(width: 4),
              option.leading!,
            ],
            const SizedBox(width: 6),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    style:
                        optionLabelStyle ??
                        TextStyle(
                          color: isEnabled ? Colors.black : Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  if (option.description != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      option.description!,
                      style:
                          descriptionStyle ??
                          TextStyle(
                            color: isEnabled
                                ? Colors.grey.shade600
                                : Colors.grey.shade400,
                            fontSize: 12,
                            height: 1.3,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (!bordered) return child;

    child = DecoratedBox(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: resolvedBorderColor),
      ),
      child: child,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: activeColor.withValues(alpha: 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
