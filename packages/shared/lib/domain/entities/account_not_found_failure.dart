import 'package:shared/domain.dart';

final class AccountNotFoundFailure extends BackendFailure {
  AccountNotFoundFailure() : super(HttpStatus.notFound);

  static const type = 'account_not_found_failure';
}
