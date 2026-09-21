import 'dart:async';

import 'package:flutter/foundation.dart';

/// Manages one async action's loading state. Use one instance per action.
///
/// Listen with ListenableBuilder, pass isLoading to AppButton.onProcess,
/// and dispose this helper when the owning State is disposed.
/// Errors are forwarded to the caller; this helper does not show messages.
class LoadingHelper extends ChangeNotifier {
  bool _isLoading = false;
  bool _isDisposed = false;

  bool get isLoading => _isLoading;

  /// Returns the action's result, or null if another action is already running.
  /// Disposing the helper stops notifications, but does not cancel the action.
  Future<T?> run<T>(FutureOr<T> Function() action) async {
    if (_isDisposed) {
      throw StateError('Cannot run an action on a disposed LoadingHelper.');
    }
    if (_isLoading) return null;

    _isLoading = true;
    try {
      notifyListeners();
      return await action();
    } finally {
      _isLoading = false;
      if (!_isDisposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
