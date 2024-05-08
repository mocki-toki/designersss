import 'package:shared/domain.dart';

final class UnknownParametersFailure extends BackendFailure {
  UnknownParametersFailure(this.parameters) : super(HttpStatus.badRequest);

  final Iterable<String> parameters;

  static const type = 'unknown_parameters_failure';

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': toSnakeCase(),
      'parameters': parameters.toList(),
    };
  }

  static UnknownParametersFailure fromJson(Map<String, dynamic> json) {
    return UnknownParametersFailure(
      (json['parameters'] as List).cast<String>(),
    );
  }
}
