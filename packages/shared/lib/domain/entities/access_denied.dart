import 'package:shared/domain.dart';

final class AccessDeniedFailure extends BackendFailure {
  AccessDeniedFailure() : super(HttpStatus.forbidden);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': toSnakeCase(),
    };
  }
}
