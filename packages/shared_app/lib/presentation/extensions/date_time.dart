import 'package:shared_app/presentation.dart';

extension DateTimeExtensions on DateTime {
  String format(BuildContext context, String format) {
    return DateFormat(format, context.locale.toString()).format(this);
  }
}
