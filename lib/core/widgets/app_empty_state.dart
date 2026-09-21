import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/constants/app_font_size.dart';
import 'package:sephsuu_care/core/widgets/app_header_1.dart';

// Sample Usage
// AppEmptyState(
//   title: 'No records yet',
//   description: 'Your saved records will appear here.',
//   icon: Icons.folder_open_rounded,
//   action: AppButton(
//     label: const Text('Add record'),
//     onPressed: handleAdd,
//   ),
// )

/// Content for an empty section. The parent decides when to show it.
class AppEmptyState extends StatelessWidget {
  final String title;
  final String? description;
  final IconData? icon;

  /// Replaces [icon] when provided, for example with an asset illustration.
  final Widget? illustration;

  /// Optional action, typically an AppButton.
  final Widget? action;
  final EdgeInsetsGeometry padding;
  final double maxWidth;
  final double iconSize;
  final Color iconColor;
  final Color titleColor;
  final Color descriptionColor;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final double spacing;

  const AppEmptyState({
    super.key,
    this.title = 'Nothing here yet',
    this.description,
    this.icon = Icons.inbox_outlined,
    this.illustration,
    this.action,
    this.padding = const EdgeInsets.all(24),
    this.maxWidth = 360,
    this.iconSize = 48,
    this.iconColor = AppColors.gray,
    this.titleColor = AppColors.dark,
    this.descriptionColor = AppColors.gray,
    this.titleStyle,
    this.descriptionStyle,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    final visual =
        illustration ??
        (icon == null ? null : Icon(icon, size: iconSize, color: iconColor));

    return Center(
      heightFactor: 1,
      child: Padding(
        padding: padding,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (visual != null) ...[visual, SizedBox(height: spacing)],
              AppHeader1(
                title,
                color: titleColor,
                fontSize: AppFontSize.lg,
                textAlign: TextAlign.center,
                style: titleStyle,
              ),
              if (description != null && description!.trim().isNotEmpty) ...[
                SizedBox(height: spacing),
                Text(
                  description!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: descriptionColor,
                    fontSize: AppFontSize.sm,
                    height: 1.5,
                  ).merge(descriptionStyle),
                ),
              ],
              if (action != null) ...[SizedBox(height: spacing), action!],
            ],
          ),
        ),
      ),
    );
  }
}
