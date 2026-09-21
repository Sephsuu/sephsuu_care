import 'package:flutter/material.dart';
import 'package:sephsuu_care/core/constants/app_color.dart';
import 'package:sephsuu_care/core/constants/app_font_size.dart';
import 'package:sephsuu_care/core/widgets/app_button.dart';
import 'package:sephsuu_care/core/widgets/app_empty_state.dart';

// Sample Usage
// AppSectionLoading(
//   isLoading: loading.isLoading,
//   isEmpty: records.isEmpty,
//   errorMessage: errorMessage,
//   onRetry: loadRecords,
//   emptyWidget: const AppEmptyState(title: 'No records yet'),
//   child: RecordsList(records: records),
// )

/// Displays a section's state in this order: loading, error, empty, content.
/// The parent owns fetching and state, and rebuilds this widget when they change.
class AppSectionLoading extends StatelessWidget {
  final bool isLoading;
  final bool isEmpty;
  final String? errorMessage;
  final Widget child;
  final Widget? loadingWidget;
  final Widget? emptyWidget;

  /// Used when [errorMessage] is nonempty.
  final Widget? errorWidget;
  final VoidCallback? onRetry;
  final String loadingLabel;
  final String errorTitle;
  final String retryLabel;
  final Color loadingColor;
  final EdgeInsetsGeometry padding;

  const AppSectionLoading({
    super.key,
    required this.isLoading,
    required this.child,
    this.isEmpty = false,
    this.errorMessage,
    this.loadingWidget,
    this.emptyWidget,
    this.errorWidget,
    this.onRetry,
    this.loadingLabel = 'Loading...',
    this.errorTitle = 'Unable to load this section',
    this.retryLabel = 'Retry',
    this.loadingColor = AppColors.pink,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final Widget content;

    if (isLoading) {
      content =
          loadingWidget ??
          _SectionLoadingIndicator(label: loadingLabel, color: loadingColor);
    } else if (errorMessage != null && errorMessage!.trim().isNotEmpty) {
      content =
          errorWidget ??
          AppEmptyState(
            title: errorTitle,
            description: errorMessage,
            icon: Icons.error_outline_rounded,
            iconColor: AppColors.red,
            action: onRetry == null
                ? null
                : AppButton(
                    label: Text(retryLabel),
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pink,
                      foregroundColor: AppColors.light,
                    ),
                    onPressed: onRetry,
                  ),
          );
    } else if (isEmpty) {
      content = emptyWidget ?? const AppEmptyState();
    } else {
      content = child;
    }

    return Padding(padding: padding, child: content);
  }
}

class _SectionLoadingIndicator extends StatelessWidget {
  final String label;
  final Color color;

  const _SectionLoadingIndicator({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 1,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: 28,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: color,
                semanticsLabel: label,
              ),
            ),
            if (label.isNotEmpty) ...[
              const SizedBox(height: 12),
              ExcludeSemantics(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.gray,
                    fontSize: AppFontSize.sm,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
