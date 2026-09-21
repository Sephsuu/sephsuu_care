import 'package:flutter/material.dart';

class DateHelper {
  DateHelper._();

  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static String formatApiDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static String formatDisplayDate(BuildContext context, DateTime date) {
    final month = MaterialLocalizations.of(
      context,
    ).formatMonthYear(date).split(' ')[0];
    return '$month ${date.day}, ${date.year}';
  }

  static String formatDateToWords(DateTime date) {
    final month = _months[date.month - 1];

    return '$month ${date.day}, ${date.year}';
  }

  static String formatApiDateToWords(String? date, {String fallback = '-'}) {
    final value = date?.trim();
    if (value == null || value.isEmpty) {
      return fallback;
    }

    final parsedDate = DateTime.tryParse(value);

    if (parsedDate == null) {
      return fallback;
    }

    return formatDateToWords(parsedDate);
  }
}
