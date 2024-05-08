import 'package:admin_backend/domain.dart';
import 'package:admin_backend/infrastructure.dart';

Future<Response> onRequest(
  RequestContext context,
  String accountId,
) {
  return switch (context.request.method) {
    HttpMethod.get => _get(context, accountId),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _get(RequestContext context, String accountId) async {
  return context
      .read<AdminAccountManagementService>()
      .getAccount(id: AccountId.fromString(accountId))
      .toResponse();
}
