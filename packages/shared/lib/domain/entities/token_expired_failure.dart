import 'package:shared/domain.dart';

final class SessionExpiredFailure extends BackendFailure {
  SessionExpiredFailure() : super(HttpStatus.badRequest);

  static const type = 'session_expired_failure';
}
