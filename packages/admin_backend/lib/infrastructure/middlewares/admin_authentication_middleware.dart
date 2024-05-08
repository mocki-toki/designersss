import 'package:admin_backend/domain.dart';
import 'package:admin_backend/infrastructure.dart';

Middleware adminAuthentication() {
  return (handler) {
    return (context) async {
      final authHeader = context.request.headers['Authorization'];
      if (authHeader == null) return handler(context);

      final parts = authHeader.split(' ');
      if (parts.length != 2 || parts[0] != 'Bearer') return handler(context);

      final token = parts[1];
      final session =
          await context.read<AdminSessionManager>().getByTokenOrNull(token);

      if (session != null) {
        if (session.expires.isBefore(DateTime.now().toUtc())) {
          await context
              .read<AdminSessionManager>()
              .deleteByAccountId(session.accountId);
          return SessionExpiredFailure().toResponse();
        }

        final account = await context
            .read<AdminAccountManager>()
            .getByIdOrNull(session.accountId);

        if (account != null) {
          return handler(context.provide<AdminAccount>(() => account));
        }
      } else {
        return SessionExpiredFailure().toResponse();
      }

      return handler(context);
    };
  };
}
