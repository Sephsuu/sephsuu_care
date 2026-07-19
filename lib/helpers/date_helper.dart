import 'package:flutter/material.dart';

class DateHelper {
  DateHelper._();

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
}
