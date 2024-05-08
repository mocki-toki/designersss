import 'dart:async';

import 'package:admin_backend/domain.dart';
import 'package:shared_backend/infrastructure.dart';

extension AdminResponseExtension on RequestContext {
  FutureOr<Response> requiredAuthorization(
    FutureOr<Response> Function() onAccepted,
  ) {
    if (readOrNull<AdminAccount>() == null) {
      return NotSignedInFailure().toResponse();
    }

    return onAccepted();
  }

  FutureOr<Response> requiredAuthAndPermissions(
    List<AdminAccountPermission> permissions,
    FutureOr<Response> Function() onAccepted,
  ) {
    final account = readOrNull<AdminAccount>();

    if (account == null) {
      return NotSignedInFailure().toResponse();
    }

    if (!account.hasPermissions(permissions)) {
      return AccessDeniedFailure().toResponse();
    }

    return onAccepted();
  }
}
