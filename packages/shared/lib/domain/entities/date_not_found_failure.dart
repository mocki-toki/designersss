import 'package:shared/domain.dart';

final class DateNotFoundFailure extends BackendFailure {
  DateNotFoundFailure() : super(HttpStatus.notFound);
}
