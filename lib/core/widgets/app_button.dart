import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';

// Sample Usage

// AppButton(
//   actionType: AppButtonActionType.add,
//   icon: const Icon(
//     Icons.add_circle_outline,
//     size: 18,
//   ),
//   label: const Text(
//     'Add Branch',
//     style: TextStyle(
//       fontSize: 14,
//       fontWeight: FontWeight.w600,
//     ),
//   ),
//   loadingLabel: const Text(
//     'Saving...',
//     style: TextStyle(
//       fontSize: 14,
//       fontWeight: FontWeight.w600,
//     ),
//   ),
//   onProcess: isSaving,
//   disabled: false,
//   width: double.infinity,
//   height: 48,
//   padding: const EdgeInsets.symmetric(
//     horizontal: 18,
//     vertical: 12,
//   ),
//   style: ElevatedButton.styleFrom(
//     backgroundColor: const Color(0xFFE67E22),
//     foregroundColor: Colors.white,
//     disabledBackgroundColor: const Color(0xFFE67E22).withOpacity(0.6),
//     disabledForegroundColor: Colors.white.withOpacity(0.8),
//     elevation: 1,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(10),
//     ),
//   ),
//   onPressed: handleSave,
// )

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
  });

  Color? get _backgroundColor {
    switch (actionType) {
      case AppButtonActionType.add:
        return AppColors.blue; // dark orange
      case AppButtonActionType.update:
        return AppColors.green; // dark green
      case AppButtonActionType.delete:
        return AppColors.red; // dark red
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

    return SizedBox(
      width: width,
      height: height ?? 44,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style:
            style ??
            ElevatedButton.styleFrom(
              backgroundColor: _backgroundColor,
              foregroundColor: Colors.white,
              disabledBackgroundColor: _backgroundColor?.withValues(alpha: 0.6),
              disabledForegroundColor: Colors.white.withValues(alpha: 0.8),
              padding:
                  padding ??
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 1,
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
