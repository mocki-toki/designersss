import 'package:main_backend/domain.dart';
import 'package:main_backend/infrastructure.dart';

Future<Response> onRequest(RequestContext context, String date) {
  return switch (context.request.method) {
    HttpMethod.get => _get(context, date),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _get(RequestContext context, String date) async {
  return context
      .read<CollectionLinkService>()
      .getLinksByDate(Date.parse(date))
      .toResponse();
}
