import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/constants/app_clay.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/constants/app_font_size.dart';
import 'package:sephsuu_care/core/widgets/app_card.dart';
import 'package:sephsuu_care/core/widgets/app_header_1.dart';

/// A scrollable dialog surface. Use AppButton widgets in [actions].
class AppModal extends StatelessWidget {
  final String title;
  final String? description;
  final Widget child;
  final List<Widget> actions;
  final bool showCloseButton;
  final VoidCallback? onClose;
  final double maxWidth;
  final EdgeInsets insetPadding;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final WrapAlignment actionsAlignment;

  const AppModal({
    super.key,
    required this.title,
    required this.child,
    this.description,
    this.actions = const [],
    this.showCloseButton = true,
    this.onClose,
    this.maxWidth = 480,
    this.insetPadding = const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 24,
    ),
    this.padding = const EdgeInsets.all(20),
    this.backgroundColor = AppColors.card,
    this.borderColor = AppColors.border,
    this.borderWidth = 1.5,
    this.borderRadius = AppClay.radius,
    this.boxShadow,
    this.titleStyle,
    this.descriptionStyle,
    this.actionsAlignment = WrapAlignment.end,
  }) : assert(maxWidth > 0);

  /// Opens a modal and returns the value passed to Navigator.pop.
  /// Use the builder's context when closing, particularly with nested navigators.
  /// [barrierDismissible] controls outside taps; use PopScope to prevent back.
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color barrierColor = const Color(0x66000000),
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) {
    return showDialog<T>(
      context: context,
      builder: builder,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      insetPadding: insetPadding,
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: AppCard(
        width: double.infinity,
        padding: EdgeInsets.zero,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        borderWidth: borderWidth,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        child: SingleChildScrollView(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Semantics(
                      namesRoute: true,
                      header: true,
                      child: AppHeader1(
                        title,
                        fontSize: AppFontSize.xl,
                        style: titleStyle,
                      ),
                    ),
                  ),
                  if (showCloseButton) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: MaterialLocalizations.of(
                        context,
                      ).closeButtonTooltip,
                      onPressed: onClose ?? () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                      color: AppColors.gray,
                    ),
                  ],
                ],
              ),
              if (description != null && description!.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  description!,
                  style: const TextStyle(
                    color: AppColors.gray,
                    fontSize: AppFontSize.sm,
                    height: 1.5,
                  ).merge(descriptionStyle),
                ),
              ],
              const SizedBox(height: 20),
              child,
              if (actions.isNotEmpty) ...[
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    alignment: actionsAlignment,
                    spacing: 12,
                    runSpacing: 12,
                    children: actions,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
