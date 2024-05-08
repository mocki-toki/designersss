import 'package:shared/domain.dart';

final class NotSignedInFailure extends BackendFailure {
  NotSignedInFailure() : super(HttpStatus.unauthorized);

  static const type = 'not_signed_in_failure';
}
