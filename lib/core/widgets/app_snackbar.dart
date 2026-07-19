import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';

enum AppSnackBarType { success, error, info }

class AppSnackBar {
  AppSnackBar._();

  static OverlayEntry? _currentEntry;

  static void show(
    BuildContext context, {
    required String message,
    AppSnackBarType type = AppSnackBarType.info,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    final overlay = Overlay.of(context);
    var dismissed = false;

    void dismiss() {
      if (dismissed) return;
      dismissed = true;
      _currentEntry
        ?..remove()
        ..dispose();
      _currentEntry = null;
    }

    _currentEntry
      ?..remove()
      ..dispose();

    _currentEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: _backgroundColor(type),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.dark.withValues(alpha: 0.18),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          message,
                          style: const TextStyle(
                            color: AppColors.light,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (action != null) ...[
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            action.onPressed();
                            dismiss();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.light,
                            minimumSize: const Size(0, 36),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          child: Text(action.label),
                        ),
                      ],
                      const SizedBox(width: 6),
                      IconButton(
                        tooltip: 'Close',
                        onPressed: dismiss,
                        style: IconButton.styleFrom(
                          foregroundColor: AppColors.light,
                          minimumSize: const Size(36, 36),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(Icons.close_rounded, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_currentEntry!);

    Future<void>.delayed(duration, () {
      if (_currentEntry?.mounted ?? false) {
        dismiss();
      }
    });
  }

  static void success(BuildContext context, String message) {
    show(context, message: message, type: AppSnackBarType.success);
  }

  static void error(BuildContext context, String message) {
    show(context, message: message, type: AppSnackBarType.error);
  }

  static void info(BuildContext context, String message) {
    show(context, message: message);
  }

  static Color _backgroundColor(AppSnackBarType type) {
    switch (type) {
      case AppSnackBarType.success:
        return AppColors.mint;
      case AppSnackBarType.error:
        return AppColors.red;
      case AppSnackBarType.info:
        return AppColors.dark;
    }
  }
}
