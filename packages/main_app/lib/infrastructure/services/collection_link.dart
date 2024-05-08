import 'package:main_app/infrastructure.dart';
import 'package:main_app/domain.dart';
import 'package:main_app/presentation.dart';

final class CollectionLinkServiceImpl implements CollectionLinkService {
  CollectionLinkServiceImpl(this._dio);
  final Dio _dio;

  @override
  Future<ListDataOrFailure<Date>> getDates() {
    return _dio.get('/collection/dates').toListData((r) => Date.fromJson(r));
  }

  @override
  Future<ListDataOrFailure<CollectionLink>> getLinksByDate(Date date) {
    return _dio
        .get(
            '/collection/links/${DateFormat('yyyy-MM-dd').format(date.dateTime)}')
        .toListData((r) => CollectionLink.fromJson(r));
  }
}
