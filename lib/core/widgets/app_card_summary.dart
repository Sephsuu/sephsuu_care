// lib/shared/widgets/app_card_summary.dart

import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';

class AppCardSummary extends StatelessWidget {
  final Widget label;
  final Widget value;
  final Widget? helper;
  final bool isNegative;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Widget? moreContent;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;

  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final TextStyle? helperStyle;

  const AppCardSummary({
    super.key,
    required this.label,
    required this.value,
    this.helper,
    this.isNegative = false,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.moreContent,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 8,
    this.boxShadow,
    this.labelStyle,
    this.valueStyle,
    this.helperStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.card,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor ?? AppColors.border),
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultTextStyle(
            style:
                labelStyle ??
                const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.8,
                  color: AppColors.blue,
                ),
            child: label,
          ),
          const SizedBox(height: 12),
          DefaultTextStyle(
            style:
                valueStyle ??
                TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: isNegative ? AppColors.red : AppColors.dark,
                ),
            child: value,
          ),
          if (helper != null) ...[
            const SizedBox(height: 4),
            DefaultTextStyle(
              style:
                  helperStyle ??
                  const TextStyle(fontSize: 14, color: AppColors.gray),
              child: helper!,
            ),
          ],
          ?moreContent,
        ],
      ),
    );
  }
}
