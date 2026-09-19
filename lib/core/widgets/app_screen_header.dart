import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/constants/app_clay.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/widgets/app_header_badge.dart';

/// A centered badge with a back button. Configure the badge through [badge].
class AppScreenHeader extends StatelessWidget {
  final AppHeaderBadge badge;
  final VoidCallback? onBack;
  final String? backTooltip;
  final EdgeInsetsGeometry padding;
  final Color backBackgroundColor;
  final Color backForegroundColor;
  final Color backBorderColor;
  final double backBorderWidth;
  final double backBorderRadius;

  const AppScreenHeader({
    super.key,
    required this.badge,
    this.onBack,
    this.backTooltip,
    this.padding = const EdgeInsets.fromLTRB(14, 8, 14, 10),
    this.backForegroundColor = AppColors.dark,
    this.backBorderColor = AppColors.light,
    this.backBorderWidth = 1.5,
    this.backBorderRadius = 24,
    this.backBackgroundColor = const Color(0xFFF3F4F6),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          // ✅ Replaced SizedBox.square + IconButton.filledTonal
          // with Container so we can use BoxShadow
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: backBackgroundColor,

              borderRadius: BorderRadius.circular(
                backBorderRadius,
              ),

              border: Border.all(
                color: backBorderColor,
                width: backBorderWidth,
              ),

              boxShadow: AppClay.shadows,
            ),
            child: IconButton(
              tooltip:
                  backTooltip ??
                  MaterialLocalizations.of(
                    context,
                  ).backButtonTooltip,

              onPressed:
                  onBack ??
                  () => Navigator.maybePop(context),

              style: IconButton.styleFrom(
                backgroundColor: backBackgroundColor,

                foregroundColor: backForegroundColor,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    backBorderRadius,
                  ),
                ),
              ),

              icon: const Icon(
                Icons.arrow_back_rounded,
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: badge,
            ),
          ),

          // Balance the back button so the badge stays centered.
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
