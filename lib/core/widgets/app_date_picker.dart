import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/constants/app_clay.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';

typedef AppDateFormatter =
    String Function(BuildContext context, DateTime date);

typedef AppDateDisabled = bool Function(DateTime date);

class AppDatePicker extends StatelessWidget {
  final String? label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  final String placeholder;
  final AppDateFormatter? formatter;

  final bool enabled;
  final bool required;

  final bool allowFutureDates;
  final bool allowedFutureDates;

  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;

  final AppDateDisabled? disabledDate;
  final SelectableDayPredicate? selectableDayPredicate;

  final Widget? leftIcon;
  final Widget? trailingIcon;
  final bool hideTrailingIcon;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;

  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final TextStyle? placeholderStyle;

  final Color fillColor;
  final Color borderColor;
  final Color focusedBorderColor;

  final double borderRadius;

  final String? helpText;
  final String? cancelText;
  final String? confirmText;

  final String? Function(DateTime?)? validator;

  const AppDatePicker({
    super.key,
    this.label,
    required this.value,
    required this.onChanged,
    this.placeholder = 'Select date',
    this.formatter,
    this.enabled = true,
    this.required = false,
    this.allowFutureDates = false,
    this.allowedFutureDates = false,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.disabledDate,
    this.selectableDayPredicate,
    this.leftIcon,
    this.trailingIcon,
    this.hideTrailingIcon = false,
    this.padding,
    this.contentPadding,
    this.labelStyle,
    this.valueStyle,
    this.placeholderStyle,

    // ✅ Default colors
    this.fillColor = AppColors.light,
    this.borderColor = AppColors.lightpink,
    this.focusedBorderColor = AppColors.pink,

    this.borderRadius = 8,
    this.helpText,
    this.cancelText,
    this.confirmText,
    this.validator,
  });

  bool get _shouldAllowFutureDates =>
      allowFutureDates || allowedFutureDates;

  DateTime _dateOnly(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  bool _isDateDisabled(DateTime date) {
    final today = _dateOnly(DateTime.now());
    final candidate = _dateOnly(date);

    if (!_shouldAllowFutureDates &&
        candidate.isAfter(today)) {
      return true;
    }

    return disabledDate?.call(candidate) ?? false;
  }

  bool _isSelectable(DateTime date) {
    if (_isDateDisabled(date)) {
      return false;
    }

    return selectableDayPredicate?.call(date) ?? true;
  }

  DateTime _resolveFirstDate() {
    return firstDate ??
        DateTime(
          DateTime.now().year - 120,
        );
  }

  DateTime _resolveLastDate() {
    if (lastDate != null) {
      return lastDate!;
    }

    final today = DateTime.now();

    if (_shouldAllowFutureDates) {
      return DateTime(
        today.year + 10,
        12,
        31,
      );
    }

    return today;
  }

  DateTime _resolveInitialDate(
    DateTime firstDate,
    DateTime lastDate,
  ) {
    final fallback =
        initialDate ??
        value ??
        DateTime.now();

    if (fallback.isBefore(firstDate)) {
      return firstDate;
    }

    if (fallback.isAfter(lastDate)) {
      return lastDate;
    }

    if (_isSelectable(fallback)) {
      return fallback;
    }

    return firstDate;
  }

  String _formatValue(
    BuildContext context,
    DateTime date,
  ) {
    if (formatter != null) {
      return formatter!(
        context,
        date,
      );
    }

    return MaterialLocalizations.of(
      context,
    ).formatMediumDate(date);
  }

  Future<void> _pickDate(
    BuildContext context,
    FormFieldState<DateTime> field,
  ) async {
    if (!enabled) return;

    final resolvedFirstDate =
        _resolveFirstDate();

    final resolvedLastDate =
        _resolveLastDate();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _resolveInitialDate(
        resolvedFirstDate,
        resolvedLastDate,
      ),
      firstDate: resolvedFirstDate,
      lastDate: resolvedLastDate,
      selectableDayPredicate: _isSelectable,
      helpText: helpText,
      cancelText: cancelText,
      confirmText: confirmText,
    );

    if (pickedDate == null) return;

    field.didChange(pickedDate);
    onChanged(pickedDate);
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: FormField<DateTime>(
        initialValue: value,
        validator: (date) {
          if (required && date == null) {
            return '$placeholder is required';
          }

          return validator?.call(date);
        },
        builder: (field) {
          final hasError = field.hasError;

          return Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              if (label != null) ...[
                Text(
                  label!,
                  style:
                      labelStyle ??
                      const TextStyle(
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w500,
                        color: AppColors.dark,
                      ),
                ),

                const SizedBox(height: 4),
              ],

              InkWell(
                onTap: () =>
                    _pickDate(
                      context,
                      field,
                    ),
                borderRadius:
                    BorderRadius.circular(
                      borderRadius,
                    ),
                child: InputDecorator(
                  isEmpty: !hasValue,
                  decoration: InputDecoration(
                    filled: true,

                    // ✅ Default white background
                    fillColor: fillColor,

                    contentPadding:
                        contentPadding ??
                        const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),

                    enabled: enabled,

                    errorText:
                        field.errorText,

                    // ✅ Light pink border
                    enabledBorder:
                        OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                                borderRadius,
                              ),
                          borderSide:
                              BorderSide(
                                color: hasError
                                    ? AppColors.red
                                    : borderColor,
                              ),
                        ),

                    // ✅ Pink focused border
                    focusedBorder:
                        OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                                borderRadius,
                              ),
                          borderSide:
                              BorderSide(
                                color:
                                    focusedBorderColor,
                                width: 1.5,
                              ),
                        ),

                    errorBorder:
                        OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                                borderRadius,
                              ),
                          borderSide:
                              const BorderSide(
                                color:
                                    AppColors.red,
                              ),
                        ),

                    focusedErrorBorder:
                        OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                                borderRadius,
                              ),
                          borderSide:
                              const BorderSide(
                                color:
                                    AppColors.red,
                                width: 1.5,
                              ),
                        ),

                    disabledBorder:
                        OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                                borderRadius,
                              ),
                          borderSide:
                              BorderSide(
                                color: AppColors
                                    .border,
                              ),
                        ),
                  ),

                  child: Row(
                    children: [
                      leftIcon ??
                          Icon(
                            Icons
                                .calendar_today_rounded,
                            size: 18,
                            color: enabled
                                ? AppColors.pink
                                : AppColors.gray,
                          ),

                      const SizedBox(
                        width: 8,
                      ),

                      Expanded(
                        child: Text(
                          hasValue
                              ? _formatValue(
                                  context,
                                  value!,
                                )
                              : placeholder,
                          maxLines: 1,
                          overflow:
                              TextOverflow
                                  .ellipsis,
                          style: hasValue
                              ? valueStyle ??
                                  const TextStyle(
                                    fontSize:
                                        14,
                                    color:
                                        AppColors
                                            .dark,
                                  )
                              : placeholderStyle ??
                                  const TextStyle(
                                    fontSize:
                                        14,
                                    color:
                                        AppColors
                                            .gray,
                                  ),
                        ),
                      ),

                      if (!hideTrailingIcon) ...[
                        const SizedBox(
                          width: 8,
                        ),

                        trailingIcon ??
                            Icon(
                              Icons
                                  .keyboard_arrow_down_rounded,
                              color: enabled
                                  ? AppColors
                                      .gray
                                  : AppColors
                                      .border,
                            ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}