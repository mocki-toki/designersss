import 'package:admin_backend/domain.dart';
import 'package:admin_backend/infrastructure.dart';

Future<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.get => _get(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _get(RequestContext context) async {
  return context.requiredAuthAndPermissions(
    [AdminAccountPermission.collection],
    () => context.read<AdminCollectionLinkService>().getDates().toResponse(),
  );
}
