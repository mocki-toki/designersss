import 'package:admin_backend/domain.dart';
import 'package:admin_backend/infrastructure.dart';

final class AdminCollectionLinkEndpoint implements AdminCollectionLinkService {
  AdminCollectionLinkEndpoint(
    this._collectionLinkManager,
  );

  final CollectionLinkManager _collectionLinkManager;

  @override
  Future<ListDataOrFailure<Date>> getDates() async =>
      successful(await _collectionLinkManager.getDates());

  @override
  Future<ListDataOrFailure<CollectionLink>> getLinksByDate(
    Date date,
  ) async {
    if (!await _collectionLinkManager.existsDate(date))
      return failed(DateNotFoundFailure());

    return successful(await _collectionLinkManager.getLinksByDate(date));
  }

  @override
  Future<DataOrFailure<void>> deleteByDate(Date date) async {
    if (!await _collectionLinkManager.existsDate(date))
      return failed(DateNotFoundFailure());

    return successful(await _collectionLinkManager.deleteByDate(date));
  }

  @override
  Future<DataOrFailure<void>> setLinksByDate(
    Date date,
    List<CollectionLink> links,
  ) async =>
      successful(await _collectionLinkManager.setLinksByDate(date, links));
}
