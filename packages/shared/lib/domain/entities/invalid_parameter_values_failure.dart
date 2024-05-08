import 'package:shared/domain.dart';

final class InvalidParameterValuesFailure extends BackendFailure {
  InvalidParameterValuesFailure(
    this.parameters,
  ) : super(HttpStatus.badRequest);

  final Iterable<InvalidParameterValue> parameters;

  static const type = 'invalid_parameter_values_failure';

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': toSnakeCase(),
      'parameters': parameters.map((e) => e.toJson()).toList(),
    };
  }

  static InvalidParameterValuesFailure fromJson(Map<String, dynamic> json) {
    return InvalidParameterValuesFailure(
      (json['parameters'] as List)
          .map((e) => InvalidParameterValue.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

final class InvalidParameterValue {
  InvalidParameterValue(
    this.parameter,
    this.unknownValues,
    this.availableValues,
  );

  final String parameter;
  final List<dynamic> unknownValues;
  final List<dynamic> availableValues;

  Map<String, dynamic> toJson() {
    return {
      'parameter': parameter,
      'unknownValues': unknownValues,
      if (availableValues.isNotEmpty) 'availableValues': availableValues,
    };
  }

  static InvalidParameterValue fromJson(Map<String, dynamic> json) {
    return InvalidParameterValue(
      json['parameter'] as String,
      json['unknownValues'] as List,
      !json.containsKey('availableValues')
          ? []
          : json['availableValues'] as List,
    );
  }
}
