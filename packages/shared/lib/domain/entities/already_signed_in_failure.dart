import 'package:shared/domain.dart';

final class AlreadySignedInFailure extends BackendFailure {
  AlreadySignedInFailure() : super(HttpStatus.conflict);

  static const type = 'already_signed_in_failure';
}
