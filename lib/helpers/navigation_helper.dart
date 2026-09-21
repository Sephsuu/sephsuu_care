import 'package:flutter/material.dart';

class NavigationHelper {
  NavigationHelper._();

  /// Opens [page] while keeping the current page in the navigation stack.
  static Future<T?> push<T>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute<T>(
        builder: (_) => page,
      ),
    );
  }

  /// Opens [page] and clears all previous routes from the nearest navigator.
  /// After async work, check context.mounted before calling this method.
  /// The returned future completes when the destination route is popped.
  static Future<T?> redirect<T>(BuildContext context, Widget page) {
    return Navigator.of(context).pushAndRemoveUntil<T>(
      MaterialPageRoute<T>(builder: (_) => page),
      (_) => false,
    );
  }
}
