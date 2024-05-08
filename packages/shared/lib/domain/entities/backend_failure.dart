import 'dart:convert';

import 'package:shared/domain.dart';

@immutable
class BackendFailure extends Failure {
  BackendFailure(this.statusCode);
  final int statusCode;

  Map<String, dynamic> toJson() {
    return {
      'type': toSnakeCase(),
    };
  }

  @override
  String toString() => "$runtimeType(${jsonEncode(toJson())})";

  String toSnakeCase() {
    return _fromCamelCaseToSnakeCase(this.runtimeType.toString());
  }

  String _fromCamelCaseToSnakeCase(String input) {
    return input
        .replaceAllMapped(
          RegExp(r'[A-Z]'),
          (match) => '_${match.group(0)!.toLowerCase()}',
        )
        .replaceFirst('_', '');
  }

  static BackendFailure fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case InvalidBodyFormatFailure.type:
        return InvalidBodyFormatFailure.fromJson(json);
      case InvalidParameterTypesFailure.type:
        return InvalidParameterTypesFailure.fromJson(json);
      case InvalidParameterValuesFailure.type:
        return InvalidParameterValuesFailure.fromJson(json);
      case MissingParametersFailure.type:
        return MissingParametersFailure.fromJson(json);
      case SessionExpiredFailure.type:
        return SessionExpiredFailure();
      case UnknownParametersFailure.type:
        return UnknownParametersFailure.fromJson(json);
      case AlreadySignedInFailure.type:
        return AlreadySignedInFailure();
      case NotSignedInFailure.type:
        return NotSignedInFailure();
      case AccountAlreadyExistsFailure.type:
        return AccountAlreadyExistsFailure();
      case AccountNotFoundFailure.type:
        return AccountNotFoundFailure();
      default:
        throw UnimplementedError('Unknown type: $type');
    }
  }
}
