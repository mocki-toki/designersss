import 'package:admin_backend/domain.dart';
import 'package:admin_backend/infrastructure.dart';

Future<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.post => _post(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _post(RequestContext context) {
  return context.read<AdminSessionService>().signOut().toResponse();
}
