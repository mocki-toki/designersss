import 'package:shared/domain.dart';
import 'package:shared_app/presentation.dart';

extension FailureExtension on Failure {
  String toLocalizedString(BuildContext context) {
    return SharedFailureLocalization.toLocalizedString(context, this);
  }
}
