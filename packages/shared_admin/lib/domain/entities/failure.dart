import 'package:shared_admin/domain.dart';

final class AdminBackendFailure extends BackendFailure {
  AdminBackendFailure(int statusCode) : super(statusCode);

  static BackendFailure fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case 'invalid_credentials_failure':
        return InvalidCredentialsFailure();
      default:
        return BackendFailure.fromJson(json);
    }
  }
}

final class InvalidCredentialsFailure extends AdminBackendFailure {
  InvalidCredentialsFailure() : super(HttpStatus.forbidden);
}
