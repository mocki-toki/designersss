import 'package:shared_app/domain.dart';
import 'package:shared_app/infrastructure.dart';
import 'package:shared_app/presentation.dart';

final class SharedFailureLocalization {
  static String toLocalizedString(BuildContext context, Failure failure) {
    final localization = context.sharedAppLocalizations;

    if (failure is BackendFailure) {
      if (failure.toSnakeCase() != 'backend_failure') {
        return localization.map[failure.toSnakeCase()] ?? failure.toSnakeCase();
      } else {
        Logger.root.severe('Unknown backend failure: ${failure.statusCode}');
        return localization.unknownServerError;
      }
    } else if (failure is NetworkFailure) {
      return localization.networkError;
    } else if (failure is DomainFailure) {
      return localization.unknownError;
    } else {
      return localization.unknownError;
    }
  }
}
