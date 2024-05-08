import 'package:admin_app/presentation.dart';
import 'package:shared/domain.dart';

extension FailureExtension on Failure {
  String toLocalizedString(BuildContext context) {
    return AdminAppFailureLocalization.toLocalizedString(context, this);
  }
}
