import 'package:shared/domain.dart';

final class AccountAlreadyExistsFailure extends BackendFailure {
  AccountAlreadyExistsFailure() : super(HttpStatus.conflict);

  static const type = 'account_already_exists_failure';
}
