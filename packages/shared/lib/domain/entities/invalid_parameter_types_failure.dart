import 'package:shared/domain.dart';

final class InvalidParameterTypesFailure extends BackendFailure {
  InvalidParameterTypesFailure(this.parameters, this.correctTypes)
      : super(HttpStatus.badRequest);
  final Iterable<String> parameters;
  final Iterable<String> correctTypes;

  static const type = 'invalid_parameter_types_failure';

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': toSnakeCase(),
      'parameters': parameters.toList(),
      'correct_types': correctTypes.map((e) => e).toList(),
    };
  }

  static InvalidParameterTypesFailure fromJson(Map<String, dynamic> json) {
    return InvalidParameterTypesFailure(
      (json['parameters'] as List).cast<String>(),
      (json['correct_types'] as List).cast<String>(),
    );
  }
}
