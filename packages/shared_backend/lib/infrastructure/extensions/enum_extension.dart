import 'package:shared_backend/domain.dart';

extension ValidationByEnum on List<Enum> {
  bool containsAllAndNotNull(List<dynamic> values) {
    if (values.isEmpty) return false;
    return values.every((e) => this.map((e) => e.name).contains(e));
  }

  InvalidParameterValue getInvalidParameterValue(
    String parameterName,
    List<dynamic> parameterValue,
  ) {
    final unknownValues = parameterValue
        .where((e) => !this.map((e) => e.name).contains(e))
        .toList();

    return InvalidParameterValue(
      parameterName,
      unknownValues,
      this.map((e) => e.name).toList(),
    );
  }
}
