import 'dart:convert';

import 'package:admin_app/infrastructure.dart';
import 'package:admin_app/domain.dart';

final class AdminCollectionLinkServiceImpl
    implements AdminCollectionLinkService {
  AdminCollectionLinkServiceImpl(this._dio);
  final Dio _dio;

  @override
  Future<ListDataOrFailure<Date>> getDates() {
    return _dio.get('/collection/dates').toListData((r) => Date.fromJson(r));
  }

  @override
  Future<ListDataOrFailure<CollectionLink>> getLinksByDate(Date date) {
    final dateTime = date.dateTime;
    return _dio
        .get(
            '/collection/links/${dateTime.year}-${dateTime.month}-${dateTime.day}')
        .toListData((r) => CollectionLink.fromJson(r));
  }

  @override
  Future<SuccessOrFailure> deleteByDate(Date date) {
    final dateTime = date.dateTime;
    return _dio
        .delete(
            '/collection/links/${dateTime.year}-${dateTime.month}-${dateTime.day}')
        .toSuccess();
  }

  @override
  Future<SuccessOrFailure> setLinksByDate(
    Date date,
    List<CollectionLink> links,
  ) {
    final dateTime = date.dateTime;
    return _dio
        .put(
          '/collection/links/${dateTime.year}-${dateTime.month}-${dateTime.day}',
          data: jsonEncode({'items': links}),
        )
        .toSuccess();
  }
}
