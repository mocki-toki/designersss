import 'package:shared_app/presentation.dart';

extension WidgetListExtension on List<Widget> {
  List<Widget> separated(Widget separator) {
    if (isEmpty) return this;
    return expand((element) => [element, separator]).toList()..removeLast();
  }
}

extension WidgetIterableExtension on Iterable<Widget> {
  List<Widget> separated(Widget separator) {
    if (isEmpty) return this.toList();
    return expand((element) => [element, separator]).toList()..removeLast();
  }
}
