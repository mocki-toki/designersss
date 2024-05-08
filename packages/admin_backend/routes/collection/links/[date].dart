import 'package:admin_backend/domain.dart';
import 'package:admin_backend/infrastructure.dart';

Future<Response> onRequest(RequestContext context, String date) async {
  if (!RegExp(r'^\d{1,2}-\d{1,2}-\d{4}$').hasMatch(date)) {
    return InvalidParameterValuesFailure([
      InvalidParameterValue('date', [date], ['dd-MM-yyyy']),
    ]).toResponse();
  }
  return switch (context.request.method) {
    HttpMethod.get => _get(context, date),
    HttpMethod.put => _put(context, date),
    HttpMethod.delete => _delete(context, date),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _get(RequestContext context, String date) async {
  return context.requiredAuthAndPermissions(
    [AdminAccountPermission.collection],
    () {
      return context
          .read<AdminCollectionLinkService>()
          .getLinksByDate(Date.parse(date))
          .toResponse();
    },
  );
}

Future<Response> _put(RequestContext context, String date) async {
  return context.requiredAuthAndPermissions(
    [AdminAccountPermission.collection],
    () => context.getRequiredParametersFromBody(
      ['items'],
      [List],
      (map) {
        final items = map['items'] as List;
        late final List<CollectionLink> links;
        try {
          links = items
              .map((e) => CollectionLink.fromJson(e as Map<String, dynamic>))
              .toList();
        } catch (_) {
          return Future.value(
            InvalidParameterValuesFailure(
              [InvalidParameterValue('items', items, [])],
            ).toResponse(),
          );
        }

        return context
            .read<AdminCollectionLinkService>()
            .setLinksByDate(Date.parse(date), links)
            .toResponse();
      },
    ),
  );
}

Future<Response> _delete(RequestContext context, String date) async {
  return context.requiredAuthAndPermissions(
    [AdminAccountPermission.collection],
    () {
      final splittedDate = date.split('-');
      final year = int.parse(splittedDate[0]);
      final month = int.parse(splittedDate[1]);
      final day = int.parse(splittedDate[2]);

      return context
          .read<AdminCollectionLinkService>()
          .deleteByDate(Date(DateTime(year, month, day)))
          .toResponse();
    },
  );
}
