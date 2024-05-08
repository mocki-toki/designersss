import 'package:admin_backend/domain.dart';
import 'package:admin_backend/infrastructure.dart';

Handler middleware(Handler handler) {
  return handler.use(
    (handler) => (context) async {
      return handler(
        context.provide<AdminSessionService>(
          () => AdminSessionEndpoint(
            context.readOrNull<AdminAccount>(),
            context.read<AdminSessionManager>(),
            context.read<AdminAccountManager>(),
          ),
        ),
      );
    },
  );
}
