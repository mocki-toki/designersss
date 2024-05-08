import 'package:shared_admin/domain.dart';

abstract interface class AdminCollectionLinkService
    implements CollectionLinkService {
  @override
  Future<ListDataOrFailure<Date>> getDates();

  @override
  Future<ListDataOrFailure<CollectionLink>> getLinksByDate(Date date);

  Future<SuccessOrFailure> deleteByDate(Date date);

  Future<SuccessOrFailure> setLinksByDate(
    Date date,
    List<CollectionLink> links,
  );
}
