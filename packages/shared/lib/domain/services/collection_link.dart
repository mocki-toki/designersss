import 'package:shared/domain.dart';

abstract interface class CollectionLinkService {
  Future<ListDataOrFailure<Date>> getDates();

  Future<ListDataOrFailure<CollectionLink>> getLinksByDate(Date date);
}
