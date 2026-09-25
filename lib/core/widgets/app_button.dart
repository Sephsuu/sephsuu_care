import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/constants/app_clay.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';

enum AppButtonActionType { add, update, delete }

class AppButton extends StatelessWidget {
  final AppButtonActionType? actionType;
  final Widget? icon;
  final Widget? label;
  final bool onProcess;
  final Widget? loadingLabel;
  final VoidCallback? onPressed;
  final bool disabled;

  final ButtonStyle? style;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;

  final List<BoxShadow>? boxShadow;

  final Color? borderColor;
  final double borderWidth;

  /// Shared radius for the button, outer border, and shadow.
  /// Takes precedence over the shape radius supplied through [style].
  final double? borderRadius;

  const AppButton({
    super.key,
    this.actionType,
    this.icon,
    this.label,
    this.onProcess = false,
    this.loadingLabel,
    this.onPressed,
    this.disabled = false,
    this.style,
    this.padding,
    this.height,
    this.width,
    this.boxShadow,
    this.borderColor = AppColors.light,
    this.borderWidth = 2,
    this.borderRadius,
  });

  Color? get _backgroundColor {
    switch (actionType) {
      case AppButtonActionType.add:
        return AppColors.blue;

      case AppButtonActionType.update:
        return AppColors.green;

      case AppButtonActionType.delete:
        return AppColors.red;

      case null:
        return null;
    }
  }

  Widget? get _actionIcon {
    if (icon != null) return icon;

    switch (actionType) {
      case AppButtonActionType.add:
        return const Icon(Icons.add, size: 18);

      case AppButtonActionType.update:
        return const Icon(Icons.edit_square, size: 18);

      case AppButtonActionType.delete:
        return const Icon(Icons.delete, size: 18);

      case null:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = disabled || onProcess;

    final Widget? resolvedIcon = onProcess
        ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : _actionIcon;

    final Widget? resolvedLabel = onProcess ? loadingLabel ?? label : label;

    return Container(
      width: width,
      height: height ?? 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
        boxShadow: boxShadow ?? AppClay.lightShadows,
        border: borderColor == null
            ? null
            : Border.all(color: borderColor!, width: borderWidth),
      ),
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style:
            (style ??
                    ElevatedButton.styleFrom(
                      backgroundColor: _backgroundColor,
                      foregroundColor: Colors.white,

                      disabledBackgroundColor: _backgroundColor?.withValues(
                        alpha: 0.6,
                      ),
                      disabledForegroundColor: Colors.white.withValues(
                        alpha: 0.8,
                      ),

                      padding:
                          padding ??
                          const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),

                      elevation: 0,
                      shadowColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                    ))
                .copyWith(
                  shape: WidgetStateProperty.resolveWith((states) {
                    return RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius ?? 8),
                      side:
                          style?.shape?.resolve(states)?.side ??
                          BorderSide.none,
                    );
                  }),
                ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (resolvedIcon != null) ...[
              resolvedIcon,
              const SizedBox(width: 8),
            ],
            ?resolvedLabel,
          ],
        ),
      ),
    );
  }
}
