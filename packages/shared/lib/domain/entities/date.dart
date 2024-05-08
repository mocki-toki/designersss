import 'package:shared/domain.dart';

@immutable
final class Date {
  Date(DateTime dateTime)
      : dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day);
  final DateTime dateTime;

  Map<String, dynamic> toJson() {
    return {
      'date': '${dateTime.toIso8601String()}',
    };
  }

  static Date fromJson(Map<String, dynamic> json) {
    return Date(
      DateTime.parse(json['date'] as String),
    );
  }

  static Date parse(String formattedString) {
    return Date(DateTime.parse(formattedString));
  }

  static Date now() {
    return Date(DateTime.now());
  }

  bool isBefore(Date other) {
    return dateTime.isBefore(other.dateTime);
  }

  bool isAfter(Date other) {
    return dateTime.isAfter(other.dateTime);
  }

  @override
  String toString() => '${dateTime.year}-${dateTime.month}-${dateTime.day}';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Date && other.dateTime == dateTime;
  }

  @override
  int get hashCode => dateTime.hashCode;
}

extension DateTimeToDate on DateTime {
  Date toDate() => Date(this);
}
