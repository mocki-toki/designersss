import 'package:shared/domain.dart';

final class InvalidBodyFormatFailure extends BackendFailure {
  InvalidBodyFormatFailure(this.message) : super(HttpStatus.badRequest);

  final String message;

  static const type = 'invalid_body_format_failure';

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': toSnakeCase(),
      'message': message,
    };
  }

  static InvalidBodyFormatFailure fromJson(Map<String, dynamic> json) {
    return InvalidBodyFormatFailure(json['message'] as String);
  }
}
