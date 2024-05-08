import 'package:shared/domain.dart';

final class MissingParametersFailure extends BackendFailure {
  MissingParametersFailure(this.parameters) : super(HttpStatus.badRequest);

  final Iterable<String> parameters;

  static const type = 'missing_parameters_failure';

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': toSnakeCase(),
      'parameters': parameters.toList(),
    };
  }

  static MissingParametersFailure fromJson(Map<String, dynamic> json) {
    return MissingParametersFailure(
      (json['parameters'] as List).cast<String>(),
    );
  }
}
