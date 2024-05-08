import 'package:main_backend/domain.dart';
import 'package:main_backend/infrastructure.dart';

final class CollectionLinkEndpoint implements CollectionLinkService {
  CollectionLinkEndpoint(
    this._collectionLinkManager,
  );

  final CollectionLinkManager _collectionLinkManager;

  @override
  Future<ListDataOrFailure<Date>> getDates() async {
    final data = await _collectionLinkManager.getDates();
    return successful(
      data
          .where(
            (e) => e.isBefore(Date.now()),
          )
          .toList(),
    );
  }

  @override
  Future<ListDataOrFailure<CollectionLink>> getLinksByDate(
    Date date,
  ) async {
    if (!await _collectionLinkManager.existsDate(date))
      return failed(DateNotFoundFailure());

    return successful(await _collectionLinkManager.getLinksByDate(date));
  }
}
