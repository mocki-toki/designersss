import 'package:admin_backend/domain.dart';
import 'package:admin_backend/infrastructure.dart';

final class AdminProfileEndpoint implements AdminProfileService {
  AdminProfileEndpoint(
    this._accountManager,
    this._profileManager,
  );

  final AdminAccountManager _accountManager;
  final AdminProfileManager _profileManager;

  Future<DataOrFailure<AdminProfile>> getProfile({
    required AccountId accountId,
  }) async {
    if (await _accountManager.getByIdOrNull(accountId) == null)
      return failed(AccountNotFoundFailure());

    return successful(await _profileManager.getByAccountIdOrCreate(accountId));
  }
}
