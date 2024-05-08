import 'package:shared_admin/domain.dart';

abstract interface class AdminProfileService {
  Future<DataOrFailure<AdminProfile>> getProfile({
    required AccountId accountId,
  });
}
