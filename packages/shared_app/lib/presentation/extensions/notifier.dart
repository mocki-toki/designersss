import 'package:flutter/widgets.dart';

extension NotifierExtensions<T> on ValueNotifier<T> {
  Widget builder(
    Widget Function(BuildContext context, T value, Widget? child) builder, {
    Widget? child,
  }) {
    return ValueListenableBuilder<T>(
      valueListenable: this,
      builder: (context, value, child) {
        return builder(context, value, child);
      },
      child: child,
    );
  }
}
