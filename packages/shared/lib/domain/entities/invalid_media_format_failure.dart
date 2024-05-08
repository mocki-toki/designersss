import 'package:shared/domain.dart';

final class InvalidMediaFormatFailure extends BackendFailure {
  InvalidMediaFormatFailure() : super(HttpStatus.badRequest);
}
